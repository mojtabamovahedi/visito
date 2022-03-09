import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visito/page/login.dart';
import 'package:visito/page/profilestore.dart';

class Home extends StatefulWidget {
  String access;
  int id;
  Home({Key? key,required this.access, required this.id}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List allStores = [];
  List<String> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getStore();
  }

  @override
  Widget build(BuildContext context) {
    if(loading){
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else{
      List showStore = allStores;
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Scaffold(
            drawer: MenuDrawer(),
            appBar: AppBar(
              title: const Text("Stores"),
              centerTitle: true,
            ),
            body: Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  const SizedBox(height: 7.5,),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: SearchField(
                      suggestions: users,
                      hint: "search",
                      onTap:(name){
                        var searchStore = allStores.where((element) => element["name"] == name);
                        List stores = [];
                        for(int i=0;i<searchStore.length;i++){
                          stores.add(searchStore.elementAt(i));
                        }
                        setState(() {
                          showStore = stores;
                          //setSuggetation();
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                        print("the user => $users");
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: showStore.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context,int index){
                          var store = showStore[index];
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
        allStores = response.data;
        setState(() {
          loading = false;
        });
        setSuggetation();
      }
      print(allStores);
      print(response.data);
    }catch(e) {
      print("error:");
      print(e);
    }
  }

  void setSuggetation(){
    users.clear();
    for(int i=0;i<allStores.length;i++){
      var temp = allStores[i];
      setState(() {
        users.add(temp["name"].toString());
      });
    }
  }
}

class MenuDrawer extends StatefulWidget {
  MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green[200],
      child: ListView(
        children:  [
          // DrawerHeader(
          // child: Text('Side menu',style: TextStyle(color: Colors.white, fontSize: 25)),
          // ),
          ListTile(
            title: const Text("EXIT"),
            leading: const Icon(Icons.exit_to_app),
            onTap: () => exitProccess(),
          )
        ],
      ),
    );
  }

  void exitProccess() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("username", "");
    sharedPreferences.setString("password", "");
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Login())
    );
  }
}

