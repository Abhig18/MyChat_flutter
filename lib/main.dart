import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/views/chatroomsScreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getLoggedInState();
    // TODO: implement initState
    super.initState();
  }

  getLoggedInState() async {
    var iflag;
    try {
      iflag = await HelperFunctions.getUserLoggedInSharedPreference();
      setState(() {
        Constants.flag = iflag;
      });
    } catch (e) {
      print('Error is:');
      print(e.toString());
      await HelperFunctions.saveUserLoggedInSharedPreference(false);
      setState(() {
        Constants.flag = false;
      });
    }
    if (iflag == null) {
      Constants.flag = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Constants.flag == null ? loading() : Authenticate());
  }
}
