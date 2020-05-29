import 'package:dail_up/dailup.dart';
import 'package:dail_up/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _phoneController = TextEditingController();
final _nameController = TextEditingController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var phone = prefs.getString('phoneno');
  print(phone);
  runApp(
    MaterialApp(
      home: phone == null ? DailUp() : Dailup(phone: phone),
    ),
  );
}

class DailUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dail up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //fontFamily: 'SF Pro Display',
        primaryColor: Color(0xFF44d489),
        accentColor: Color(0xFF302F2F),
      ),
      home: LogIn(),
    );
  }
}

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          '',
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 35, left: 20),
                    width: double.infinity,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 380,
                    margin: EdgeInsets.only(top: 20),
                    child: TextField(
                      controller: _nameController,
                      textAlign: TextAlign.left,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.supervised_user_circle),
                        hintText: 'Name',
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
                    width: 380,
                    margin: EdgeInsets.only(top: 20),
                    child: TextField(
                      controller: _phoneController,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'Phone Number',
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
                        final phone = _phoneController.text.trim();
                        final name = _nameController.text.trim();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Verification(name, phone),
                          ),
                        );
                      },
                      child: Text(
                        "Send Code",
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
                  Container(
                    margin: EdgeInsets.only(left: 0),
                    child: FlatButton(
                      onPressed: () {
                        print("Some help");
                      },
                      child: Text(
                        'Need Help?',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
