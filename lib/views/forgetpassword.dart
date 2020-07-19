import 'package:chat_app/services/auth.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  bool isloading = false;
  TextEditingController email = new TextEditingController();
  AuthMethods auth = new AuthMethods();
  bool valid = false;
  bool visible = false;
  String txt;
  void resetPwd() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      await auth.resetPwd(email.text);
      setState(() {
        isloading = false;
        valid = true;
        txt = email.text;
        email.text = '';
        visible = true;
      });
    }
  }

  Widget showText() {
    return valid
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'A reset password link has been sent to',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  txt,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? loading()
        : Scaffold(
            appBar: appBarMain(context),
            body: Container(
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                    ),
                    Form(
                      key: formKey,
                      child: TextFormField(
                          validator: (val) {
                            bool flag = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val);
                            return !flag || val.isEmpty
                                ? 'Enter a valid email ID'
                                : null;
                          },
                          controller: email,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration('email')),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Visibility(
                      visible: !visible,
                      child: GestureDetector(
                        onTap: () {
                          resetPwd();
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
                            'Reset Password',
                            style: simpleTextStyle(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    showText(),
                    SizedBox(
                      height: 30,
                    ),
                    Visibility(
                      visible: visible,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
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
                            'Sign in Page',
                            style: simpleTextStyle(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
