import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController username = new TextEditingController();
  QuerySnapshot snapshot;
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  String error;
  @override
  void initState() {
    username.text = Constants.myName;
    error = ' ';
    // TODO: implement initState
    super.initState();
  }

  void updateDetails() async {
    if (formKey.currentState.validate()) {
      // await HelperFunctions.saveUsernameSharedPreference(username.text);
      // Constants.myName = username.text;
      snapshot = await Database.updateUsername(username.text);

      print('Updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Row(
          children: <Widget>[
            Icon(
              Icons.settings,
              color: Colors.white,
            ),
            SizedBox(
              width: 7,
            ),
            Text(
              'Settings',
              style: simpleTextStyle(),
            )
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Update username',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                          validator: (val) {
                            return (val.isEmpty || val.length < 4)
                                ? 'Please provide a valid username'
                                : null;
                          },
                          controller: username,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration('username')),
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                    ],
                  )),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(
                height: 45,
              ),
              GestureDetector(
                onTap: () async {
                  await updateDetails();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(colors: [
                      Colors.blue[700],
                      Colors.blue[800],
                    ]),
                  ),
                  child: Text(
                    'Update',
                    style: simpleTextStyle(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
