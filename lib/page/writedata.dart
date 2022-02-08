import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class Write extends StatefulWidget {
  const Write({Key? key}) : super(key: key);

  @override
  _WriteState createState() => _WriteState();
}


class _WriteState extends State<Write> {
  final database = FirebaseDatabase.instance.reference();
  int Last = 0;
  @override
  void initState() {
    super.initState();
    findLastOne();
  }

  void findLastOne() async {
    int lastCode = await database.child("store/").orderByKey().limitToLast(1).once().then((snapshot) {
      return (snapshot.value.values).toList()[0]["code"];
    });
    Last = lastCode + 1;
    print("last code => $lastCode");
  }

  Widget build(BuildContext context) {
    
    
    String _name = '';
    String _phoneNumber = '';
    Map _listStuff_rob = {
      'دلپذیر':0,
      'رعنا':0,
      'طبیعت':0,
      'چین چین':0,
    };
    Map _listStuff_pasta = {
      'تک ماکارون':0,
      'رشد':0,
      'زر ماکارون':0,
      'ساوین':0,
    };
    List<Map> _listStuff= [
      _listStuff_rob,
      _listStuff_pasta
    ];


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('write data'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          child: Column(
            children: [
              TextField(
                onChanged:(text){
                  _name = text;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'نام و نام خانوادگی'
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (text){
                  _phoneNumber = text;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'شماره تماس'
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    try{
                      final store = database.child('store/$Last/');
                      await store
                          .set({'name': _name, 'phone number': _phoneNumber, 'code': Last});
                      List<String> nameStuff = ['رب','ماکارونی'];
                      for(int i=0;i<nameStuff.length;i++){
                        String stuff = nameStuff[i];
                        final staff = database.child('store/$Last/list stuff/$stuff');
                        await staff.set(_listStuff[i]);
                      }
                      Last++;
                      print('set goooooooood\n');

                      print('name is $_name and phone number is $_phoneNumber');
                    }catch (e){
                      print('we got => $e');
                    }
                  },
                  child: const Text('ثبت'))
            ],
          ),
        ),
      ),
    );
  }
}
