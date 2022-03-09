import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
class Visitation extends StatefulWidget {
  String access;
  final int id;
  final int user;
  Visitation({Key? key, required this.access,required this.id, required this.user}) : super(key: key);

  @override
  _VisitationState createState() => _VisitationState();
}

class _VisitationState extends State<Visitation> {
  List visitations = [];
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    getVisitation();
  }
  @override
  Widget build(BuildContext context) {
    if(_loading){
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else{
      return Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await getVisitation();
              },
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: visitations.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map visit = visitations[index];
                    return Column(
                      children: [
                        const SizedBox(height: 3,),
                        VisitCard(storeId:widget.id,user: widget.user, id:visit["id"],face: visit["face"],sku: visit["sku"],date: visit["date"],brandId: visit["brand"],access: widget.access,),
                        const SizedBox(height: 3,),
                      ],
                    );
                  }
              ),
            ),
          )
        ],
      );
    }
  }

  Future<void> getVisitation() async {
    Dio dio = Dio();
    Response response = await dio.get(
      "http://rvisito.herokuapp.com/api/v1/visitation/?store_id=${widget.id}",
      options: Options(headers: {"authorization":"Bearer ${widget.access}"})
    );
    if(response.statusCode == 200){
      visitations = response.data;
      setState(() {
        _loading = false;
      });
    }
    print("response is => ${response.data}");
  }
}

class VisitCard extends StatefulWidget {
  int storeId;
  int user;
  int id;
  int brandId;
  double face;
  double sku;
  String date;
  String access;
  VisitCard({Key? key,required this.storeId,required this.user,required this.access, required this.id,required this.face,required this.sku,required this.date,required this.brandId}) : super(key: key);

  @override
  State<VisitCard> createState() => _VisitCardState();
}

class _VisitCardState extends State<VisitCard> {
  late String newSKU;
  late String newFACE;
  bool _editVisitation = false;

  SnackBar snackBar(String textSnap){
    final finalSnackBar = SnackBar(
      content: Text(textSnap),
      duration: const Duration(seconds: 2),
    );
    return finalSnackBar;
  }

  @override
  Widget build(BuildContext context) {
    List<String> time = widget.date.split("T");
    time[1]=time[1].substring(0,time[1].length-1);
    return Container(
      padding: const EdgeInsets.fromLTRB(6.0, 0, 6.0, 0),
      child: Container(
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.green[200],
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5.0),top: Radius.circular(5.0)),
        ),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(0),
              child: InkWell(
                child: Column(
                  children: [
                    Text("brand id: ${widget.brandId}", style: const TextStyle(fontSize: 16.0),),
                    const SizedBox(height: 2.5,),
                    Row(
                      children: [
                        Text("sku: ${widget.sku}",style: const TextStyle(fontSize: 16.0),),
                        const Spacer(),
                        Text("face: ${widget.face}",style: const TextStyle(fontSize: 16.0),),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _editVisitation = !_editVisitation;
                  });
                },
              ),
            ),
            Visibility(
              visible: !(_editVisitation),
              child: Row(
                children: [
                  const SizedBox(width: 5,),
                  Text(time[0],style: TextStyle(color: Colors.grey[700]),),
                  const Spacer(),
                  Text(time[1],style: TextStyle(color: Colors.grey[700]),),
                  const SizedBox(width: 5,),
                ],
              ),
            ),
            Visibility(
              visible: _editVisitation,
              child: Row(
                children: [
                  const SizedBox(width: 15,),
                  Container(
                    color: Colors.white,
                    width: 70,
                    height: 35,
                    child: TextField(
                      onChanged: (text) {
                        newSKU = text;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(4)],
                      decoration: const InputDecoration(
                        hintText: "enter",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(),
                        label: Center(child: Text("NEW SKU")),
                        labelStyle: TextStyle(fontSize: 9.0),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 35,
                    width: 70,
                    color: Colors.white,
                    child: TextField(
                      onChanged: (text) {
                        newFACE = text;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(4)],
                      decoration: const InputDecoration(
                        hintText: "enter",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(),
                        label: Center(child: Text("NEW FACE",)),
                        labelStyle: TextStyle(fontSize: 9.0),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await updateVisitation(newSKU, newFACE);
                    },
                  ),
                  const SizedBox(width: 2.5,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateVisitation(String sku, String face) async {
    try{
      final response = await http.put(
        Uri.parse("http://rvisito.herokuapp.com/api/v1/visitation/${widget.id}"),
        headers:{
          "Authorization":"Bearer ${widget.access}",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body:{
          "date": widget.date,
          "face": face,
          "sku": sku,
          "user": widget.user.toString(),
          "brand" : widget.brandId.toString(),
          "store" : widget.storeId.toString(),
        }
      );
      if(response.statusCode == 200){

        ScaffoldMessenger.of(context).showSnackBar(snackBar("successfully updated"));
      }else{

        ScaffoldMessenger.of(context).showSnackBar(snackBar("failed update"));
      }
    }catch(e){
      snackBar("failed update");
      print(e);
    }
  }
}
