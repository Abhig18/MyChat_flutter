import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatroomsScreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  bool isloading = false;
  bool obscure = true;
  bool valid;
  String error = '';
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      new TextEditingController();
  signMeUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      dynamic result = await authMethods.signUnWithEmailAndPassword(
          emailTextEditingController.text.trim(),
          passwordTextEditingController.text.trim());

      if (result == null) {
        setState(() {
          isloading = false;
          error = 'Could not register with those credentials';
          valid = false;
        });
      } else {
        setState(() {
          isloading = false;
          print('valid');
          valid = true;
          Map<String, String> userInfoMap = {
            'email': emailTextEditingController.text,
            'name': userNameTextEditingController.text
          };
          HelperFunctions.saveUserPasswordSharedPreference(
              passwordTextEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(
              emailTextEditingController.text);
          HelperFunctions.saveUsernameSharedPreference(
              userNameTextEditingController.text);
          print('Username is : ${userNameTextEditingController.text}');
          Database.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Constants.myName = userNameTextEditingController.text.trim();
          Constants.email = emailTextEditingController.text.trim();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                  return (val.isEmpty || val.length < 4)
                                      ? 'Please provide a valid username'
                                      : null;
                                },
                                controller: userNameTextEditingController,
                                style: simpleTextStyle(),
                                decoration:
                                    textFieldInputDecoration('username')),
                            SizedBox(
                              height: 5,
                            ),
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
                                decoration: textFieldInputDecoration('email')),
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
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                                obscureText: obscure,
                                validator: (val) {
                                  return confirmPasswordTextEditingController
                                              .text !=
                                          passwordTextEditingController.text
                                      ? 'Password is not matching'
                                      : null;
                                },
                                controller:
                                    confirmPasswordTextEditingController,
                                style: simpleTextStyle(),
                                decoration: textFieldInputDecoration(
                                    'Confirm password')),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      ),
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
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await signMeUp();
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
                            'Sign Up',
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
                          'Sign Up With Google',
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
                            'Already have an account? ',
                            style: simpleTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Sign in',
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
