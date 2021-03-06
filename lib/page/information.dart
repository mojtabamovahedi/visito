import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

bool _brandsLoading = false;
bool _visibaleButton = false;
String snapBarMessage = "";
List brand = [];
List brand_id = [];
late List skulist ;
late List faceList ;
List resultColor = [Colors.white,Colors.white,Colors.white,Colors.white,Colors.white];

class InputTab extends StatefulWidget {
  String access;
  List productName;
  List productId;
  final int storeId;
  final int userId;
  InputTab({Key? key, required this.access, required this.productName, required this.productId,required this.storeId, required this.userId}) : super(key: key);

  @override
  _InputTabState createState() => _InputTabState();
}

class _InputTabState extends State<InputTab> {

  SnackBar snackBar(String textSnap, int duration) {
    final finalSnackBar = SnackBar(content: Text(textSnap),
      duration: Duration(seconds: duration),
    );
    return finalSnackBar;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 9,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            color: Colors.grey[200],
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.productName.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          brand.clear();
                          _brandsLoading = true;
                        });
                        List tempListForBrand = [];
                        List tempListForBrandId = [];
                        try {
                          Dio dio = Dio();
                          Response responseForBrand = await dio.get(
                            "http://rvisito.herokuapp.com/api/v1/brand/?product_id=${widget
                                .productId[index]}",
                            options: Options(headers: {
                              "authorization": "Bearer ${widget.access}"
                            }),
                          );
                          List dataOfBrand = responseForBrand.data;
                          tempListForBrand.clear();
                          tempListForBrandId.clear();
                          for (int j = 0; j < dataOfBrand.length; j++) {
                            var temp = dataOfBrand[j];
                            tempListForBrand.add(temp["name"]);
                            tempListForBrandId.add(temp["id"]);
                          }
                        } catch (e) {
                          print(e);
                        }
                        setState(() {
                          resultColor = [
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white
                          ];
                          _visibaleButton = true;
                          _brandsLoading = false;
                          brand = tempListForBrand;
                          brand_id = tempListForBrandId;
                          skulist = List.filled(brand.length, "");
                          faceList = List.filled(brand.length, "");
                        });
                        print("brand => $brand");
                        print("brand id => $brand_id");
                      },
                      child: Column(
                        children: [
                          const SizedBox(height: 4.0),
                          const CircleAvatar(
                            backgroundImage: AssetImage('image/stuff.jpeg'),
                            radius: 25.0,
                          ),
                          const SizedBox(height: 2.0,),
                          Text(widget.productName[index]),
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
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
          child: Visibility(
            visible: _brandsLoading,
            child: const LinearProgressIndicator(),
          ),
        ),
        const SizedBox(height: 5.0,),
        Expanded(
          flex: 25,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: brand.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: resultColor[index],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4.5, 0, 4.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 10.0,),
                        Flexible(
                          flex: 4,
                          child: Row(
                            children: [
                              const Icon(Icons.radio_button_off, size: 10.0,),
                              Text(" ${brand[index]}",
                                style: const TextStyle(fontSize: 15.0),),
                            ],
                          ),
                        ),
                        const Spacer(flex: 1,),
                        Flexible(
                          flex: 2,
                          child: Container(
                            color: Colors.white,
                            width: 100,
                            height: 35,
                            child: TextField(
                              onChanged: (text) {
                                skulist[index] = text;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4)
                              ],
                              decoration: const InputDecoration(
                                hintText: "enter",
                                hintStyle: TextStyle(fontSize: 12.0),
                                border: OutlineInputBorder(),
                                label: Center(child: Text("SKU")),
                                labelStyle: TextStyle(fontSize: 10.0),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                        Flexible(
                          flex: 2,
                          child: Container(
                            color: Colors.white,
                            width: 100,
                            height: 35,
                            child: TextField(
                              onChanged: (text) {
                                faceList[index] = text;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4)
                              ],
                              decoration: const InputDecoration(
                                hintText: "enter",
                                hintStyle: TextStyle(fontSize: 12.0),
                                border: OutlineInputBorder(),
                                label: Center(child: Text("FACE",)),
                                labelStyle: TextStyle(fontSize: 10.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15.0,)
                      ],
                    ),
                  ),
                );
              }
          ),
        ),
        Center(
          child: Visibility(
            visible: _visibaleButton,
            child: TextButton(
              child: const Text(
                "send data",
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                checkInput();
                print(skulist);
                print(faceList);
              },
            ),
          ),
        ),
      ],
    );
  }

  void checkInput() {
    for (int i = 0; i < skulist.length; i++) {
      if ((skulist[i].isEmpty && faceList[i].isEmpty) || (skulist[i].isNotEmpty && faceList[i].isNotEmpty)) {
        setState(() {
          resultColor[i] = Colors.yellow[100];
        });
      } else {
        setState(() {
          resultColor[i] = Colors.red[100];
        });
        ScaffoldMessenger.of(context).showSnackBar(
            snackBar("Some thing wrong", 3));
        print("*** ${skulist[i]} ${faceList[i]}");
        return;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar("All check", 1));
    createVisitations();
  }

  void createVisitations() async {
    for (int i = 0; i < skulist.length; i++) {
      if (skulist[i].isNotEmpty && faceList[i].isNotEmpty) {
        await _createVisitation(skulist[i],faceList[i],brand_id[i],i);
      }
      snapBarMessage = "Nothing add";
    }
    ScaffoldMessenger.of(context).showSnackBar((snackBar(snapBarMessage,3)));
  }

  Future<void> _createVisitation(String SKU, String FACE, int brandId,int num) async {
    String now = getTime();
    Dio dio = Dio();
    Response responseForBrand = await dio.post(
        "http://rvisito.herokuapp.com/api/v1/visitation/",
        options: Options(headers: {
          "authorization": "Bearer ${widget.access}",
          "Content-Type": "application/x-www-form-urlencoded"
        }),
        data: {
          "user": widget.userId,
          "brand": brandId,
          "store": widget.storeId,
          "date": now,
          "face": FACE,
          "sku": SKU
        }
    );
    if (responseForBrand.statusCode == 201) {
      setState(() {
        snapBarMessage = "Successfully registered";
        resultColor[num] = Colors.green[100];
      });
    } else if (responseForBrand.statusCode == 400) {
      snapBarMessage = "sending ERROR";
      resultColor[num] = Colors.red[400];
    }
  }

}

String getTime(){
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
  String formattedDate = formatter.format(now);
  print(formattedDate);
  return formattedDate;
}