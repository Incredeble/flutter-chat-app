import 'package:flutter/material.dart';
import 'package:mate_rate/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Login Successfull",
                style: TextStyle(fontSize: 30.0, color: Colors.white),
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
                  'Logout',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 30.0,
                  ),
                ),
                onPressed: () {
                  _auth.signOut();
                  Navigator.of(context).pushReplacementNamed(LoginScreen.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
