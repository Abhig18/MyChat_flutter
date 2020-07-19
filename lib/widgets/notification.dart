import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  void onClick1() {
    print('Inside init function');
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      final snackbar = SnackBar(
        content: Text(message['notification']['title']),
        action: SnackBarAction(
          label: 'Go',
          onPressed: () => null,
        ),
      );
      Scaffold.of(context).showSnackBar(snackbar);
      print(message);
    }, onResume: (Map<String, dynamic> message) async {
      print(message);
    }, onLaunch: (Map<String, dynamic> message) async {
      print(message);
    });
  }

  @override
  void initState() {
    onClick1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
