import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'pswdReset.dart';

class ForgotScreen extends StatefulWidget {
  static const String id = "forgotScreen";
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  String email, otp, message1 = "", message2 = "";
  bool otpSend = false,
      userExsist = false,
      showSpinner = false,
      verifyOtp = false,
      visible = false,
      mess1 = false,
      mess2 = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void data() {
    if (otpSend) {
      setState(() {
        showSpinner = false;
        message1 = "OTP Send Succssfully";
        setState(() {
          visible = true;
          mess1 = true;
        });
      });
      Timer(Duration(seconds: 4), () {
        setState(() {
          message1 = "";
          mess1 = false;
        });
      });
    } else {
      setState(() {
        showSpinner = false;
        message1 = "OTP failed";
        mess1 = true;
      });
    }
    Timer(Duration(seconds: 4), () {
      setState(() {
        message1 = "";
        mess1 = false;
      });
    });
  }

  Future exsist(String email) async {
    await Firestore.instance
        .collection('users')
        .document(email)
        .get()
        .then((DocumentSnapshot document) {
      if (document.data != null) {
        sendOTP(email);
      } else {
        setState(() {
          showSpinner = false;
          message1 = "User not exsist";
          mess1 = true;
        });
        Timer(Duration(seconds: 4), () {
          setState(() {
            message1 = "";
            mess1 = false;
          });
        });
      }
    }).catchError((_) {
      setState(() {
        showSpinner = false;
        message1 = "User not exsist";
        mess1 = true;
      });
      Timer(Duration(seconds: 4), () {
        setState(() {
          message1 = "";
          mess1 = false;
        });
      });
    });
  }

  Future sendOTP(String email) async {
    EmailAuth.sessionName = "Password Reset";
    bool result = await EmailAuth.sendOtp(receiverMail: email);
    if (result) {
      setState(() {
        otpSend = true;
      });
    } else {
      setState(() {
        otpSend = false;
      });
    }
    data();
  }

  Future otpVerify(String email, String otp) {
    bool res = EmailAuth.validate(receiverMail: email, userOTP: otp);
    if (res) {
      setState(() {
        verifyOtp = true;
      });
    } else {
      setState(() {
        verifyOtp = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Forgot",
                    style: TextStyle(color: Colors.white, fontSize: 45.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Password",
                    style: TextStyle(color: Colors.white, fontSize: 45.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.teal,
                          ),
                          suffix: InkWell(
                            child: Text(
                              "Send OTP",
                              style: TextStyle(color: Colors.teal),
                            ),
                            onTap: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              await exsist(email);
                            },
                          ),
                          hintText: "Enter email",
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
                      SizedBox(
                        height: 20.0,
                        child: Visibility(
                          visible: mess1,
                          child: Container(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(message1,
                                textAlign: TextAlign.right,
                                style: otpSend
                                    ? TextStyle(
                                        color: Colors.white, fontSize: 15)
                                    : TextStyle(
                                        color: Colors.red, fontSize: 15)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Visibility(
                        visible: visible,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefix: Text(
                              "OTP ",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold),
                            ),
                            hintText: "Enter OTP",
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
                          onChanged: (value) {
                            otp = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                        child: Visibility(
                          visible: mess2,
                          child: Container(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(message2,
                                textAlign: TextAlign.right,
                                style: verifyOtp
                                    ? TextStyle(
                                        color: Colors.white, fontSize: 15)
                                    : TextStyle(
                                        color: Colors.red, fontSize: 15)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
                      'Verify',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 30.0,
                      ),
                    ),
                    onPressed: () async {
                      if (visible) {
                        setState(() {
                          showSpinner = true;
                        });
                        await otpVerify(email, otp);
                        if (verifyOtp) {
                          setState(() {
                            showSpinner = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PasswordScreen(email: email)));
                        } else {
                          setState(() {
                            message2 = "Wrong OTP";
                            showSpinner = false;
                            mess2 = true;
                          });
                          Timer(Duration(seconds: 4), () {
                            setState(() {
                              message2 = "";
                              mess2 = false;
                            });
                          });
                        }
                      } else {
                        setState(() {
                          message1 = "Please Enter OTP";
                          mess1 = true;
                        });
                        Timer(Duration(seconds: 4), () {
                          setState(() {
                            mess1 = false;
                            message1 = "";
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
      ),
    );
  }
}
