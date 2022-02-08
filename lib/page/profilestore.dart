import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:visito/shape/stuffwidget.dart';

class ProfileStore extends StatefulWidget {
  final int code;

  const ProfileStore({Key? key, required this.code}) : super(key: key);

  @override
  _ProfileStoreState createState() => _ProfileStoreState();
}

class _ProfileStoreState extends State<ProfileStore> {
  final database = FirebaseDatabase.instance.reference();
  String name = '';
  String phoneNumber = '';
  String sabtErorr = "";
  List nameStuff = ["رب", "ماکارونی", "کالباس", "کمپوت","لیوان"];
  List isVisible = [];
  List COarr = [];
  Map COmap = {
    "رب": ["دلپذیر", "رعنا", "خوش مشرب"],
    "ماکارونی": ["تک", "زر", "رعنا"],
    "کالباس": ["تهران", "مشد", "قم"],
    "کمپوت": ["گیلاس", "سیب", "گلابی!"],
    "لیوان":["زرین","سفالی","کتابی","قاسمی",]
  };

  @override
  void initState() {
    super.initState();
    activeListener();
  }

  void activeListener() {
    String num = widget.code.toString();
    //name
    database.child('store/$num/name/').onValue.listen((event) {
      final String temp = event.snapshot.value;
      setState(() {
        name = temp;
      });
    });

    //phone number
    database.child('store/$num/phone number/').onValue.listen((event) {
      final String temp = event.snapshot.value;
      setState(() {
        phoneNumber = temp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //for(){}
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('صفحه فروشنده'),
          centerTitle: true,
        ),
        body: Container(
          height: size - 80,
          color: Colors.grey[200],
          child: Center(
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: Text(
                      name,
                      textAlign: TextAlign.right,
                    ),
                    subtitle: Text(
                      phoneNumber,
                      textAlign: TextAlign.right,
                    ),
                    isThreeLine: true,
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('image/dogecoin.jpg'),
                      radius: 35.0,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      DefaultTabController(
                          length: 2,
                          initialIndex: 0,
                          child: Column(
                            children: [
                              Container(
                                child: const TabBar(
                                    isScrollable: false,
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.blueGrey,
                                    tabs: [
                                      Tab(text: "تغییرات"),
                                      Tab(text: 'موجود')
                                    ]),
                              ),
                              Container(
                                color: Colors.grey[200],
                                height: size - 225,
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                              color: Colors.grey[300],
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                itemCount: nameStuff.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Row(
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {setState(() {
                                                          COarr = COmap[nameStuff[index]];
                                                          sabtErorr = "";
                                                          });
                                                        },
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(height: 5.0),
                                                            const CircleAvatar(
                                                              backgroundImage: AssetImage('image/stuff.jpeg'),
                                                              radius: 25.0,
                                                            ),
                                                            const SizedBox(height: 2.0,),
                                                            Text(nameStuff[index]),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 2.5,)
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5.0,),
                                          Expanded(
                                            flex: 7,
                                            child: ListView.builder(
                                                itemCount: COarr.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                    int index) {
                                                  return Card(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Flexible(
                                                          flex: 3,
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.radio_button_off,
                                                                size: 15.0,
                                                              ),
                                                              Text(
                                                                COarr[index],
                                                                style: const TextStyle(fontSize: 20.0),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Spacer(flex: 1,),
                                                        Flexible(
                                                          flex: 2,
                                                          child: SizedBox(
                                                            width: 70,
                                                            height: 30,
                                                            child: TextField(onChanged: (text) {
                                                                //nothing
                                                              },
                                                              keyboardType:
                                                              TextInputType
                                                                  .number,
                                                              decoration:
                                                              const InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'SKU',
                                                                labelStyle: TextStyle(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(flex: 1),
                                                        Flexible(
                                                          flex: 2,
                                                          child: SizedBox(
                                                            width: 70,
                                                            height: 30,
                                                            child: TextField(onChanged: (text) {
                                                                //nothing
                                                              },
                                                              keyboardType:
                                                              TextInputType
                                                                  .number,
                                                              decoration:
                                                              const InputDecoration(
                                                                border:
                                                                OutlineInputBorder(),
                                                                labelText: 'FACE',
                                                                labelStyle:
                                                                TextStyle(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(flex: 1),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: ColoredBox(
                                              color: Colors.blueGrey,
                                              child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    sabtErorr = "اصلاعات با موفقیت ثتب شد";
                                                  });
                                                },
                                                child: const Text("ثبت",
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                sabtErorr,
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                                itemCount: nameStuff.length,
                                                itemBuilder:
                                                    (BuildContext context, int index) {
                                                  return Column(
                                                    children: [
                                                      Card(
                                                      child: ListTile(
                                                        title: Text(nameStuff[index], textAlign: TextAlign.right,),
                                                        onTap: () {
                                                        setState(() {isVisible[index] = !isVisible[index];});
                                                  },
                                                  ),
                                                  ),
                                                  Visibility(
                                                  visible: isVisible[index],
                                                  child: Container(
                                                    child: ListOfStuff(printer: COmap[nameStuff[index]],)
                                                  )
                                                  ),
                                                  ],
                                                  );
                                                }),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}



//print list of stuff

class ListOfStuff extends StatelessWidget {
  List printer;
  ListOfStuff({Key? key, required this.printer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int len = printer.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 33.0*len,
      child: ListView.builder(
          itemCount: printer.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(printer[index],textAlign: TextAlign.right,),
                ],
              ),
            );
          }),
    );
  }
}

