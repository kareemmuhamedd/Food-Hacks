import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  final String name;
  Test({this.name = 'NoName'});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.name),
    );
  }
}
