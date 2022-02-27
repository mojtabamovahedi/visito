import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:dio/dio.dart';
import 'package:visito/page/profilestore.dart';

class Home extends StatefulWidget {
  String access;
  String refresh;
  int id;
  Home({Key? key,required this.access,required this.refresh, required this.id}) : super(key: key);

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
    users.clear();
    for(int i=0;i<stores.length;i++){
      var temp = stores[i];
      users.add(temp["name"].toString());
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
                            title: Text("${store["name"]}" , textAlign: TextAlign.right,),
                            subtitle: Text("${store["address"]}", textAlign: TextAlign.right,),
                            onTap: (){
                              Navigator.push(
                                context,
                                  MaterialPageRoute(builder: (BuildContext context) => ProfileStore(
                                    storeId: store["id"], name: store["name"], address: store["address"],access: widget.access,userId: widget.id,
                                  ))
                              );
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

  void getStore() async {
    try{
      Dio dio = Dio();
      Response response = await dio.get(
        "http://rvisito.herokuapp.com/api/v1/store/",
        options: Options(headers: {"authorization":"Bearer ${widget.access}"}),
      );
      if(response.statusCode == 200){
        stores = response.data;
        setState(() {
          loading = false;
        });
      }
      print(response.data);
    }catch(e) {
      print("error:");
      print(e);
    }
  }

}
