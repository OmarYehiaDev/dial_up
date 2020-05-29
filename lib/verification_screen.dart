import 'package:dail_up/dailup.dart';
import 'package:flutter/material.dart';

class Verification extends StatelessWidget {
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
              )),
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Dailup()));
              },
              child: Text(
                "Register",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 18,
                    fontFamily: 'Roboto'),
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
