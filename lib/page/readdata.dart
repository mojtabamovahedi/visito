import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:visito/page/profilestore.dart';

class Read extends StatefulWidget {

  int Last;
  Read({Key? key, required this.Last}) : super(key: key);

  @override
  _ReadState createState() => _ReadState();
}

class _ReadState extends State<Read> {
  final database = FirebaseDatabase.instance.reference();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست فروشندگان'),
        centerTitle: true,
      ),
      body:  Center(
        child: StreamBuilder(
          stream: database.child('store/').orderByKey().limitToLast(2).onValue,
          builder: (context, snapshot){
            final cardlist = <Card> [];
            if(snapshot.hasData){
              Map names = Map.from((snapshot.data! as Event).snapshot.value);
              names.forEach((key, value) {
                final nextName = Map.from(value);
                ListTile nameTile = ListTile(
                  leading: const Icon(Icons.person),
                  tileColor: Colors.grey[100],
                  title: Text(nextName['name'], textAlign: TextAlign.right,),
                  subtitle: Text(nextName['phone number'], textAlign: TextAlign.right,),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileStore(code: nextName["code"]))
                    );
                  },
                );
                cardlist.add(Card(child: nameTile));
                print(value);
              });
            }
            return Expanded(
                child: ListView(
                  children: cardlist,
                )
            );
          },
        )
      ),
    );
  }

}
