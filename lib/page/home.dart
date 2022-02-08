import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:visito/page/readdata.dart';
import 'package:visito/page/writedata.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final database = FirebaseDatabase.instance.reference();
  late final int Last;

  @override
  void initState(){
    super.initState();
    findLastOne();
  }

  void findLastOne() async {
    int lastCode = await database.child("store/").orderByKey().limitToLast(1).once().then((snapshot) {
      return (snapshot.value.values).toList()[0]["code"];
    });
    Last = lastCode;
    print("last code => $lastCode");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست مغازه ها'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
             children: [
              ElevatedButton(
                  onPressed: () async{
                    try{
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Write())
                      );
                    }catch(e){
                      print('ERROR');
                      print(e);
                    }
                  },
                  child: const Text('write data')
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async{
                    try{
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Read(Last: Last,)));
                    }catch(e){
                      print('ERROR');
                      print(e);
                    }
                  },
                  child: const Text('read base')
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: SearchField(
                  suggestions: [],
                  hint: 'جستجو',
                ),
              ),
              const SizedBox(height: 15),
              const Text('    '),
            ],
          )
      ),
    );
  }
}

Future<bool> sendData() async {


  return false;
}
