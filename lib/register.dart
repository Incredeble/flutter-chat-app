import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = "registerScreen";
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(myInterceptor);
  }

  void disopose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if ([LoginScreen.id].contains(info.currentRoute(context))) {
      return false;
    }
    return true;
  }

  final _auth = FirebaseAuth.instance;
  bool show = true, showSpinner = false;
  String name, contact, email, password, userExsist = "";

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

  String contactNumberValidate(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length != 10) {
      return 'Please enter 10 digits mobile number';
    }
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
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
      backgroundColor: Colors.teal,
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
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                  color: Colors.white,
                ),
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
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.teal,
                          ),
                          hintText: "Enter Name",
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value.length < 3) {
                            return "Please enter a valid last name.";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 7.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.teal,
                          ),
                          hintText: "Enter Email",
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide.none,
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
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                          prefixIcon: Icon(
                            Icons.contact_phone,
                            color: Colors.teal,
                          ),
                          hintText: "Enter contact number",
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: contactNumberValidate,
                        onChanged: (value) {
                          contact = value;
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
                          fillColor: Colors.grey[300],
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.teal,
                          ),
                          suffix: InkWell(
                            child: Icon(
                              Icons.visibility,
                              color: Colors.teal,
                            ),
                            onTap: passwordVisibility,
                          ),
                          hintText: "Enter Password",
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide.none,
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
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.teal),
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
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              await _auth
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password)
                                  .then((currentUser) => Firestore.instance
                                          .collection("users")
                                          .document(currentUser.email)
                                          .setData({
                                        "email": currentUser.email,
                                        "password": password,
                                        "name": name,
                                        "contact": contact,
                                      }).then((result) => {
                                                Navigator.pushNamed(
                                                        context, LoginScreen.id)
                                                    .then((_) => _formKey
                                                        .currentState
                                                        .reset())
                                              }));
                              setState(() {
                                showSpinner = false;
                              });
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
                            color: Colors.teal,
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
                              color: Colors.teal,
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
