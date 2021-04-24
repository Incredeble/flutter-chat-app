import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = "registerScreen";
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool show = true, showSpinner = false;
  String email, password, userExsist = "";

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
                  padding: EdgeInsets.only(top: 50.0, bottom: 20),
                  child: Text(
                    "Register",
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
                    color: Colors.blueAccent,
                  )),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.only(top: 20.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      child: Text(
                        userExsist,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 7.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.blueAccent,
                          ),
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.blueAccent),
                          hintText: "Enter Email",
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 7.0),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 40)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueAccent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                          ),
                        ),
                        onPressed: () async {
                          print(
                              'affffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              final newUser = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password);
                              setState(() {
                                showSpinner = false;
                              });
                              if (newUser != null) {
                                Navigator.of(context)
                                    .pushReplacementNamed(LoginScreen.id);
                              }
                            } catch (e) {
                              setState(() {
                                show = true;
                                showSpinner = false;
                                userExsist = "User Already Exsist";
                              });
                              _formKey.currentState.reset();
                              Timer(Duration(seconds: 3), () {
                                setState(() {
                                  userExsist = "";
                                });
                              });
                            }
                          } else {
                            setState(() {
                              show = true;
                              showSpinner = false;
                              userExsist = "User Already Exsist";
                            });
                            _formKey.currentState.reset();
                            Timer(Duration(seconds: 3), () {
                              setState(() {
                                userExsist = "";
                              });
                            });
                            print(
                                'bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account ? ",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20.0,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.id)
                                .then((_) => _formKey.currentState.reset());
                          },
                          child: Text(
                            "Login Now",
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
