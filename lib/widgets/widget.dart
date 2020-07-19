import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.blue[800],
    title: Text('My Chat'),
  );
}

InputDecoration textFieldInputDecoration(String hint) {
  return InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue[800])),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white);
}

Scaffold loading() {
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.blue[800],
      title: Text('My Chat'),
    ),
    body: Center(
      child: SpinKitFadingCircle(
        color: Colors.blue,
        size: 50.0,
      ),
    ),
  );
}
