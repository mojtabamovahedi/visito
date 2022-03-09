import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'information.dart';
import 'visitations.dart';

List product = [];
List productName = [];
List productId = [];
bool _pageLoading = true;



class ProfileStore extends StatefulWidget {
  String access;
  int userId;
  final int storeId;
  final String name;
  final String address;
  ProfileStore({Key? key, required this.storeId, required this.name, required this.address, required this.access, required this.userId}) : super(key: key);

  @override
  _ProfileStoreState createState() => _ProfileStoreState();
}

class _ProfileStoreState extends State<ProfileStore> {

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  void getProduct() async {
    product.clear();
    productName.clear();
    productId.clear();
    try{
      Dio dio = Dio();
      Response response = await dio.get(
        "http://rvisito.herokuapp.com/api/v1/product/?store_id=${widget.storeId}",
        options: Options(headers: {"authorization":"Bearer ${widget.access}"}),
      );
      print(response.data);
      product = response.data;
      setState(() {
        for(int i=0;i<product.length;i++){
          var temp = product[i];
          productName.add(temp["name"]);
          productId.add(temp["id"]);
        }
      });
      setState(() {
        _pageLoading = false;
      });
    }catch (e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {

    double size = MediaQuery.of(context).size.height;
    if(_pageLoading){
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else{
      return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          _pageLoading = true;
          brand.clear();
          return true;
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: const Text('Profile'),
                centerTitle: true,
                leading: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                    _pageLoading = true;
                    brand.clear();
                  },
                  icon: const Icon(Icons.keyboard_backspace),
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  height: size - 80,
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(
                      children: [
                        Information(name: widget.name, address: widget.address),
                        Column(
                          children: [
                            DefaultTabController(
                                length: 2,
                                initialIndex: 0,
                                child: Column(
                                  children: [
                                    const TabBar(
                                        isScrollable: false,
                                        labelColor: Colors.black,
                                        unselectedLabelColor: Colors.blueGrey,
                                        tabs: [
                                          Tab(text: "Add information"),
                                          Tab(text: 'History of visitation')
                                        ]),
                                    Container(
                                      color: Colors.grey[200],
                                      height: size - 225,
                                      child: TabBarView(
                                        physics: const NeverScrollableScrollPhysics(),
                                        children: [
                                          InputTab(access: widget.access, productName: productName,productId: productId, storeId: widget.storeId,userId: widget.userId),
                                          Visitation(access: widget.access, id: widget.storeId,user : widget.userId)
                                        ],
                                      ),
                                    )
                                  ],
                                )
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ),
      );
    }
  }

}

//information of store man
class Information extends StatelessWidget {
  String name;
  String address;
  Information({Key? key, required this.name, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: ListTile(
          title: Text(
            name,
            textAlign: TextAlign.right,
          ),
          subtitle: Text(
            address,
            textAlign: TextAlign.right,
          ),
          isThreeLine: true,
          leading: const CircleAvatar(
            backgroundImage: AssetImage('image/dogecoin.jpg'),
            radius: 35.0,
          ),
        ),
      ),
    );
  }
}
