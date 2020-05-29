import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

//dial pad package Documentation here
//https://pub.dev/packages/flutter_dialpad#-readme-tab-
class Dailup extends StatefulWidget {
  final String phone;
  final String name;
  Dailup({this.phone, this.name});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Dailup> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Text("Logout"),
          backgroundColor: Colors.orange,
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('phoneno');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext ctx) => Dail_up(),
              ),
            );
          },
        ),
        backgroundColor: Theme.of(context).accentColor,
        body: Container(
          margin: EdgeInsets.only(top: 50),
          child: SafeArea(
            child: DialPad(
              enableDtmf: true,
              outputMask: "(000) 000-0000",
              backspaceButtonIconColor: Colors.red,
              makeCall: (number) {
                print(number);
              },
            ),
          ),
        ),
      ),
    );
  }
}
