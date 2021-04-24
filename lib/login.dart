import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'register.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "loginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    print("------------------------------------------------------");
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        Navigator.pushNamed(context, HomeScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  bool show = true, showSpinner = false;
  String email, password, validCredentials = "";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void passwordVisibility() {
    setState(() {
      show = !show;
    });
  }

  String emailValidator(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String passwordValidator(String password) {
    if (password.length < 6) {
      return 'Password must be longer than 6 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  padding: EdgeInsets.symmetric(vertical: 60.0),
                  child: Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                    color: Colors.blue,
                  )),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.only(top: 30.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        validCredentials,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.blueAccent,
                          ),
                          labelText: "Username",
                          labelStyle: TextStyle(color: Colors.blueAccent),
                          hintText: "Enter Username",
                          hintStyle: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                        validator: emailValidator,
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        obscureText: show,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blueAccent,
                          ),
                          suffix: InkWell(
                            child: Icon(
                              Icons.visibility,
                              color: Colors.blueAccent,
                            ),
                            onTap: passwordVisibility,
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.blueAccent),
                          hintText: "Enter Password",
                          hintStyle: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                        validator: passwordValidator,
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 40)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blueAccent),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            if (_formKey.currentState.validate()) {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
                              setState(() {
                                showSpinner = false;
                              });
                              _formKey.currentState.reset();
                              Navigator.of(context)
                                  .pushReplacementNamed(HomeScreen.id);
                            }
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                              show = true;
                              validCredentials = "Invalid Credentials";
                            });
                            _formKey.currentState.reset();
                            Timer(Duration(seconds: 3), () {
                              setState(() {
                                validCredentials = "";
                              });
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account ? ",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20.0,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegisterScreen.id)
                                .then((_) => _formKey.currentState.reset());
                          },
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
