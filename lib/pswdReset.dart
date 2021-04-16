import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'dart:async';

class PasswordScreen extends StatefulWidget {
  final email;
  PasswordScreen({this.email});
  static const String id = "passwordScreen";
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  String password, confirmPassword, message = "";
  bool show = true, mess = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future changePassword() async {
    print("mail : ${widget.email}");
    final _auth = Firestore.instance;
    _auth
        .collection('users')
        .document('${widget.email}')
        .updateData({"password": password})
        .then((value) => {
              setState(() {
                mess = true;
                message = "Password changed Succssfully";
                Timer(Duration(seconds: 2), () {
                  setState(() {
                    message = "";
                  });
                  Navigator.of(context).pushReplacementNamed(LoginScreen.id);
                });
              })
            })
        .catchError((_) => {
              setState(() {
                mess = false;
                message = "User not exsist";
              }),
              Timer(Duration(seconds: 2), () {
                setState(() {
                  message = "";
                });
              }),
              print("User not Exsist")
            });
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
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
                child: TextFormField(
                  obscureText: show,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.teal,
                    ),
                    suffix: InkWell(
                      child: Icon(
                        Icons.visibility,
                        color: Colors.teal,
                      ),
                      onTap: () {
                        setState(() {
                          show = !show;
                        });
                      },
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
                child: TextFormField(
                  obscureText: show,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.teal,
                    ),
                    suffix: InkWell(
                      child: Icon(
                        Icons.visibility,
                        color: Colors.teal,
                      ),
                      onTap: () {
                        setState(() {
                          show = !show;
                        });
                      },
                    ),
                    hintText: "Enter password again",
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
                    confirmPassword = value;
                  },
                ),
              ),
              SizedBox(
                height: 20.0,
                child: Container(
                  child: Text(
                    message,
                    style: mess
                        ? TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          )
                        : TextStyle(
                            color: Colors.red,
                            fontSize: 15.0,
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 15, horizontal: 40)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    'Update Password',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 30.0,
                    ),
                  ),
                  onPressed: () async {
                    if (password == confirmPassword) {
                      await changePassword();
                    } else {
                      setState(() {
                        mess = false;
                        message = "Password not matched";
                      });
                      Timer(Duration(seconds: 4), () {
                        setState(() {
                          message = "";
                        });
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
