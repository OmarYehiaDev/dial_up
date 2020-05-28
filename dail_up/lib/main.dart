import 'package:dail_up/dailup.dart';
import 'package:dail_up/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _phoneController = TextEditingController();
final _codeController = TextEditingController();
final _nameController = TextEditingController();
final databaseReference = Firestore.instance;

Future<bool> loginUser(String phone,String name, BuildContext context) async{
  FirebaseAuth _auth = FirebaseAuth.instance;
  _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async{
        Navigator.of(context).pop();

        AuthResult result = await _auth.signInWithCredential(credential);

        FirebaseUser user = result.user;
        
        if(user != null){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('phoneno', user.phoneNumber);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Dailup(phone: user.phoneNumber,name:name)
          ));
        }else{
          print("Error");
        }

      },
      verificationFailed: (AuthException exception){
        print(exception.message);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("verification failed"),
        ));
      },
      codeSent: (String verificationId, [int forceResendingToken]){
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
                    onPressed: () async{
                      final code = _codeController.text.trim();
                      AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);

                      AuthResult result = await _auth.signInWithCredential(credential);

                      FirebaseUser user = result.user;

                      if(user != null){
                      final snapShot= await databaseReference.collection("users").document(user.uid).get();
                        if(snapShot.exists){
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('phoneno', user.phoneNumber);
                          prefs.setString('name', name);
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => Dailup(phone: user.phoneNumber,)
                          ));
                        }
                        else{
                          await databaseReference.collection("users").document(user.uid).
                            setData({
                              'userName': name,
                              'phone': user.phoneNumber
                            });
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('phoneno', user.phoneNumber);
                          prefs.setString('name', name);
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => Dailup(phone: user.phoneNumber,name:name)
                          ));
                        }
                      }else{
                        print("Error");
                      }
                    },
                  )
                ],
              );
            }
        );
      },
      codeAutoRetrievalTimeout: null
  );
}


  Future<void> main() async {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var phone = prefs.getString('phoneno');
      print(phone);
      runApp(MaterialApp(home: phone == null ? Dail_up() : Dailup(phone:phone)));
    }

class Dail_up extends StatelessWidget {

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
        home: LogIn()
    );
  }

}

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
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
                      color: Theme
                          .of(context)
                          .accentColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
                  child: Column(children: <Widget>[

                    Container(
                      margin:EdgeInsets.only(top: 35, left: 20),
                      width: double.infinity,
                      child: Text('Register', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'Roboto', color: Colors.white),),
                    ),
                    Container(
                        width: 380,
                        margin: EdgeInsets.only(top: 20),
                        child: TextField(
                          controller: _nameController,
                          textAlign: TextAlign.left,
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
                        )),                    
                    Container(
                        width: 380,
                        margin: EdgeInsets.only(top: 20),
                        child: TextField(
                          controller: _phoneController,
                          textAlign: TextAlign.left,
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
                        )),
                    Container(
                      width: 180,
                      margin: const EdgeInsets.only(top: 20.0),
                      child: FlatButton(
                        splashColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.only(top:15, bottom: 15,),
                        onPressed: () {
                          final phone = _phoneController.text.trim();
                          final name=_nameController.text.trim();
                        loginUser(phone,name, context);},
                        child:
                        Text(
                          "Send Code",
                          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18, fontFamily: 'Roboto'),
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
                        onPressed: (){


                        },
                        child: Text('Need Help?', style: TextStyle(fontWeight:FontWeight.normal, color: Colors.white, fontFamily: 'Roboto', fontSize: 18),),
                      ),

                    ),


                  ],),

                ),
              )
            ]
        )
    );



  }

}
