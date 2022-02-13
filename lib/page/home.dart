import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class Home extends StatefulWidget {
  String access;
  String refresh;
  Home({Key? key,required this.access,required this.refresh}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List stores = [];
  List<String> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getStore();
  }

  @override
  Widget build(BuildContext context) {
    for(int i=0;i<stores.length;i++){
      var temp = stores[i];
      users.add(temp["user"].toString());
    }
    if(loading){
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else{
      return Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                const SizedBox(height: 7.5,),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: SearchField(
                    suggestions: users,
                    hint: "search",
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: stores.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context,int index){
                        var store = stores[index];
                        return Card(
                          color: Colors.white70,
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text("${store["user"]}" , textAlign: TextAlign.right,),
                            subtitle: Text("${store["id"]}", textAlign: TextAlign.right,),
                            onTap: (){

                            },
                          ),
                        );
                      }
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  void getStore() async{
    var response = await http.get(
      Uri.parse("http://rvisito.herokuapp.com/api/v1/visitor/"),
      headers: {"authorization":"Bearer ${widget.access}"},);
    if(response.statusCode == 200){
      var jsonResponse = convert.jsonDecode(response.body);
      stores = jsonResponse;
      setState(() {
        loading = false;
      });
    }
  }
}
