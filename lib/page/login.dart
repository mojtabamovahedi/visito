import 'package:flutter/material.dart';
import 'package:visito/page/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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

class LoginRequest {
  String? username;
  String? password;

  LoginRequest({this.username, this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

class APIservice {
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final response = await http.post(
      Uri.parse('http://rvisito.herokuapp.com/api-auth/login/'),
      body: {
        'username': loginRequest.username,
        'password': loginRequest.password
      },
    );
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      return LoginResponse(refresh: '', access: '', id: 0);
    }
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

late String userName;
late String password;

class _LoginState extends State<Login> {
  bool boolVar = false;
  late LoginRequest request;

  @override
  void initState() {
    super.initState();
    request = LoginRequest();
  }

  final usernameController = TextEditingController();
  bool validateUsername = false;

  final passwordController = TextEditingController();
  bool validatePassword = false;

  String failedLoginError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
           child: Column(
            children: [
              Container(
                height: 150.0,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                    color: Colors.indigo,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(15.0))),
              ),
              const SizedBox(height: 100,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: TextField(
                      controller: usernameController,
                      onChanged: (text) {
                        request.username = text;
                      },
                      decoration: InputDecoration(border: const OutlineInputBorder(),
                          labelText: 'user name',
                        errorText: validateUsername ? 'Username Can\'t Be Empty' : null
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: TextField(
                      controller: passwordController,
                      onChanged: (text) {
                        request.password = text;
                      },
                      obscureText: true,
                      decoration: InputDecoration(border: const OutlineInputBorder(),
                          labelText: 'password',
                        errorText: validatePassword ? 'Username Can\'t Be Empty' : null
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(failedLoginError, style: const TextStyle(color: Colors.red),),
              const SizedBox(height: 10),
              Visibility(
                visible: !boolVar,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                  child: const Text('ENTER'),
                  onPressed: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if(usernameController.text.isEmpty || passwordController.text.isEmpty){
                      if(usernameController.text.isEmpty){
                        setState(() {
                          validateUsername = true;
                        });
                      }else{
                        setState(() {
                          validateUsername = false;
                        });
                      }
                      if(passwordController.text.isEmpty){
                        setState(() {
                          validatePassword = true;
                        });
                      }else{
                        setState(() {
                          validatePassword = false;
                        });
                      }
                    }

                    if(usernameController.text.isNotEmpty || passwordController.text.isNotEmpty){
                      setState(() {
                        boolVar = !boolVar;
                      });
                      APIservice apiService = APIservice();
                      apiService.login(request).then((value){
                        if(value.access.isNotEmpty){
                          print(value.id);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => Home(access: value.access,refresh: value.refresh,id: value.id)));
                        }else{
                          setState(() {
                            failedLoginError = "username or password is WRONG!";
                            boolVar = !boolVar;
                          });
                        }
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Visibility(
                visible: boolVar,
                child: const CircularProgressIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
