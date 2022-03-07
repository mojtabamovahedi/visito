import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';


class Visitation extends StatefulWidget {
  String access;
  final int id;
  Visitation({Key? key, required this.access,required this.id}) : super(key: key);

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
      return Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: visitations.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map visit = visitations[index];
                    return Column(
                      children: [
                        VisitCard(id:visit["id"],face: visit["face"],sku: visit["sku"],date: visit["date"],brandId: visit["brand"],),
                      ],
                    );
                  }
              ),
            )
          ],
        ),
      );
    }
  }

  void getVisitation() async {
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

class VisitCard extends StatelessWidget {
  int id;
  int brandId;
  double face;
  double sku;
  String date;
  VisitCard({Key? key,required this.id,required this.face,required this.sku,required this.date,required this.brandId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> time = date.split("T");
    time[1]=time[1].substring(0,time[1].length-1);
    return Container(
      padding: const EdgeInsets.fromLTRB(4.5, 0, 4.5, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(6.0, 0, 10, 0),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5.0),top: Radius.circular(5.0)),
        ),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Text("brand id: $brandId", style: const TextStyle(fontSize: 16.0),),
                  Row(
                    children: [
                      Text("face: $face",style: const TextStyle(fontSize: 16.0),),
                      const Spacer(),
                      Text("sku: $sku",style: const TextStyle(fontSize: 16.0),),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 5,),
                Text(time[0],style: TextStyle(color: Colors.grey[700]),),
                const Spacer(),
                Text(time[1],style: TextStyle(color: Colors.grey[700]),),
                const SizedBox(width: 5,),
              ],
            )
          ],
        ),
      ),
    );
  }
}
