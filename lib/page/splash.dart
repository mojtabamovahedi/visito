import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visito/page/home.dart';
import 'package:visito/page/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
String finalUsername = "";
String finalPassword = "";

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    getValue().whenComplete(() async{
      await Future.delayed(const Duration(seconds: 2), () {
        if(finalUsername == null || finalPassword == null){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const Login()));
        }else{
          print("if ro rad kardi");
          autoLogin(finalUsername, finalPassword);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
        child:  CircularProgressIndicator(),
      ),
    );
  }

  Future getValue() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var username = sharedPreferences.getString("username");
    var password = sharedPreferences.getString("password");
    setState(() {
      finalUsername = username!;
      finalPassword = password!;
    });
    print("username => $finalUsername password => $finalPassword");
  }


  Future autoLogin(String username, String password) async {
    try{
      final response = await http.post(
        Uri.parse('http://rvisito.herokuapp.com/api-auth/login/'),
        body: {
          'username': username,
          'password': password
        },
      );
      if(response.statusCode == 200){
        var finalResponse = LoginResponse.fromJson(json.decode(response.body));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Home(access: finalResponse.access, id: finalResponse.id))
        );
      }else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => const Login())
        );
      }
    }catch(e){
      print("error is $e");
    }
  }
}

class LoginResponse {
  String refresh;
  String access;
  int id;
  LoginResponse({required this.refresh, required this.access, required this.id});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        refresh: json["refresh"] ?? "",
        access: json["access"] ?? "",
        id: json["id"] ?? ""
    );
  }
}
