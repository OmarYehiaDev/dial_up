import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dail_up/dailup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _codeController = TextEditingController();
final databaseReference = Firestore.instance;

Future<bool> _loginUser(String phone, String name, BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  _auth.verifyPhoneNumber(
    phoneNumber: phone,
    timeout: Duration(seconds: 60),
    verificationCompleted: (AuthCredential credential) async {
      Navigator.of(context).pop();

      AuthResult result = await _auth.signInWithCredential(credential);

      FirebaseUser user = result.user;

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('phoneno', user.phoneNumber);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dailup(
              phone: user.phoneNumber,
              name: name,
            ),
          ),
        );
      } else {
        print("Error");
      }
    },
    verificationFailed: (AuthException exception) {
      print(exception.message);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("verification failed"),
        ),
      );
    },
    codeSent: (String verificationId, [int forceResendingToken]) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Give the code?"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _codeController,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Confirm"),
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () async {
                  final code = _codeController.text.trim();
                  AuthCredential credential = PhoneAuthProvider.getCredential(
                    verificationId: verificationId,
                    smsCode: code,
                  );

                  AuthResult result =
                      await _auth.signInWithCredential(credential);

                  FirebaseUser user = result.user;

                  if (user != null) {
                    final snapShot = await databaseReference
                        .collection("users")
                        .document(user.uid)
                        .get();
                    if (snapShot.exists) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('phoneno', user.phoneNumber);
                      prefs.setString('name', name);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dailup(
                            phone: user.phoneNumber,
                          ),
                        ),
                      );
                    } else {
                      await databaseReference
                          .collection("users")
                          .document(user.uid)
                          .setData(
                        {'userName': name, 'phone': user.phoneNumber},
                      );
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('phoneno', user.phoneNumber);
                      prefs.setString('name', name);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dailup(
                            phone: user.phoneNumber,
                            name: name,
                          ),
                        ),
                      );
                    }
                  } else {
                    print("Error");
                  }
                },
              ),
            ],
          );
        },
      );
    },
    codeAutoRetrievalTimeout: null,
  );
  return null;
}

class Verification extends StatelessWidget {
  final String authName;
  final String authPhone;
  Verification(this.authName, this.authPhone);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 300,
            margin: EdgeInsets.only(top: 150),
            child: TextField(
              textAlign: TextAlign.left,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: 'Verification Code',
                hintStyle: TextStyle(fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(23),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                contentPadding: EdgeInsets.all(16),
                fillColor: Colors.white,
              ),
            ),
          ),
          Container(
            width: 180,
            margin: const EdgeInsets.only(top: 20.0),
            child: FlatButton(
              splashColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              onPressed: () {
                _loginUser(authPhone, authName, context);
              },
              child: Text(
                "Register",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(23.0),
              ),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
