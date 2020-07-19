import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatroomsScreen.dart';
import 'package:chat_app/views/forgetpassword.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/helper/helper_functions.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  final formKey = GlobalKey<FormState>();
  AuthMethods auth = new AuthMethods();
  bool isloading = false;
  bool valid, obscure = true;
  String error = '';
  QuerySnapshot userInfo;

  signMeIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      emailTextEditingController.text = emailTextEditingController.text.trim();
      passwordTextEditingController.text =
          passwordTextEditingController.text.trim();
      dynamic result = await auth.signInWithEmailAndPassword(
          emailTextEditingController.text, passwordTextEditingController.text);
      if (result == null) {
        setState(() {
          isloading = false;
          error = 'Email or password is incorrect';
          valid = false;
        });
      } else {
        userInfo =
            await Database.getUserByEmail(emailTextEditingController.text);
        await HelperFunctions.saveUserPasswordSharedPreference(
            passwordTextEditingController.text);
        await HelperFunctions.saveUserEmailSharedPreference(
            emailTextEditingController.text);
        await HelperFunctions.saveUserLoggedInSharedPreference(true);
        await HelperFunctions.saveUsernameSharedPreference(
            userInfo.documents[0].data['name']);
        setState(() {
          isloading = false;
          valid = true;
          Constants.flag = true;
          Constants.myName = userInfo.documents[0].data['name'];
          Constants.email = emailTextEditingController.text.trim();
          print('Username : ${Constants.myName}');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        });
      }
    }
  }

  void alreadyLoggedIn() async {
    String email = await HelperFunctions.getEmailSharedPreference();
    String pwd = await HelperFunctions.getPasswordSharedPreference();
    dynamic result = await auth.signInWithEmailAndPassword(email, pwd);
    userInfo = await Database.getUserByEmail(email);
    setState(() {});
    HelperFunctions.saveUsernameSharedPreference(
        userInfo.documents[0].data['name']);
    Constants.myName = userInfo.documents[0].data['name'];
    Constants.email = emailTextEditingController.text.trim();
    print('Username : ${Constants.myName}');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ChatRoom()));
  }

  @override
  Widget build(BuildContext context) {
    if (Constants.flag) {
      alreadyLoggedIn();
      return loading();
    } else {
      return isloading
          ? loading()
          : Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: appBarMain(context),
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                  validator: (val) {
                                    bool flag = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val);
                                    return !flag || val.isEmpty
                                        ? 'Enter a valid email ID'
                                        : null;
                                  },
                                  controller: emailTextEditingController,
                                  style: simpleTextStyle(),
                                  decoration:
                                      textFieldInputDecoration('email')),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                  obscureText: obscure,
                                  validator: (val) {
                                    return val.length < 6
                                        ? 'Provide a password with 6+ characters'
                                        : null;
                                  },
                                  controller: passwordTextEditingController,
                                  style: simpleTextStyle(),
                                  decoration:
                                      textFieldInputDecoration('password')),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'show password',
                                        style: simpleTextStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  print('I don\'t know my password');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ForgotPassword(),
                                      ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Forgot password?',
                                      style: simpleTextStyle(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            signMeIn();
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
                              'Sign In',
                              style: simpleTextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Text(
                            'Sign In With Google',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Don\'t have an account? ',
                              style: simpleTextStyle(),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Register now',
                                  style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 60,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
    }
  }
}
