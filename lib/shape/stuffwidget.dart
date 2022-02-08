import 'package:flutter/material.dart';

class StuffWidget extends StatefulWidget {
  final String name;
  final String image ;

  const StuffWidget({Key? key, required this.image,  required this.name}) : super(key: key);

  @override
  State<StuffWidget> createState() => _StuffWidgetState();
}

class _StuffWidgetState extends State<StuffWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
