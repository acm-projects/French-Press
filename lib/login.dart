import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';
import 'sign_in.dart';


class LoginPage extends StatefulWidget {

  LoginPage({Key key}) : super(key: key);



  @override

  _LoginPageState createState() => _LoginPageState();

}



class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  TextEditingController emailInputController;

  TextEditingController pwdInputController;


  @override
  initState() {
    emailInputController = new TextEditingController();

    pwdInputController = new TextEditingController();

    super.initState();
  }


  String emailValidator(String value) {
    Pattern pattern =

        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }


  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          color: Color(0xFFDBCFC7),
          child: SingleChildScrollView(
            child:
            Column(
              children: <Widget>[
                Image.asset("assets/AlexAssets/DavidO_FrenchPress.png", width: 550, height: 220,),
//                          Padding(
//                            padding: const EdgeInsets.all(10.0),
//                            child: Container(
//                              alignment: Alignment.topCenter,
//                                child: RichText(
//                                  text: TextSpan(text: "Welcome.", style: TextStyle(fontFamily: "Inria_Serif", fontSize: 50, fontWeight: FontWeight.bold, color: Color(0xFF442B2B)),
//                                  ),
//                              ),
//                            ),
//                          ),
                          Form(
                          key: _loginFormKey,
                          child: SafeArea(
                                  child: Container(
                                    child: Stack(
                                        children: <Widget>[
                                          Container(
                                            width: 350.0,
                                            height: 400.0,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)),color: Colors.white,
                                            )
                                          ),
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 300,
                                            child:

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                fillColor: Color(0xFF442B2B),
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Color(0xFFDBCFC7))),
                                                    labelText: 'Email*',
                                                    labelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF442B2B),),),
                                                    controller: emailInputController,
                                                    keyboardType: TextInputType.emailAddress,
                                                    validator: emailValidator,

                                    ),
                                            ),),
                                           Positioned(
                                             left: 0,
                                             right: 0,
                                             bottom: 215,
                                             child:
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                 decoration: InputDecoration(
                                                     fillColor: Color(0xFF442B2B),
                                                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Color(0xFFDBCFC7))),
                                                     labelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF442B2B)),

                                                     labelText: 'Password*',),

                                      controller: pwdInputController,

                                      obscureText: true,

                                      validator: pwdValidator,

                                    ),
                                            ),),


                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 80,
                                        child:
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(

                                              child: RichText(
                                              text: TextSpan(text: 'LOGIN', style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 3.0),)),

                                              color: Colors.brown,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

                                              textColor: Color(0xffeee2),

                                              onPressed: () {
                                                if (_loginFormKey.currentState.validate()) {
                                              FirebaseAuth.instance

                                                .signInWithEmailAndPassword(

                                                email: emailInputController.text,

                                                password: pwdInputController.text)

                                                .then((currentUser) =>
                                                Firestore.instance

                                                    .collection("users")

                                                    .document(currentUser.uid)

                                                    .get()

                                                    .then((DocumentSnapshot result) =>

                                                    Navigator.pushReplacement(

                                                        context,

                                                        MaterialPageRoute(

                                                            builder: (context) =>
                                                                HomePage(

                                                                  title: currentUser
                                                                      .displayName,

                                                                  uid: currentUser.uid,

                                                                ))))
                                                    .catchError((err) => print(err)))
                                                .catchError((err) => print(err));
                                        }
                                      },

                                    ),
                                          ),),

                                        Positioned(
                                          right: 0,
                                          left: 0,
                                          bottom: 25,
                                          child:
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              child: (Row(children: <Widget>[Image.asset("assets/AlexAssets/Google_Logo.png", fit: BoxFit.scaleDown, width: 30, height: 20),Text("SIGN IN THROUGH GOOGLE", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Montserrat',fontSize: 12.5, fontWeight: FontWeight.normal, letterSpacing: 3.0, color: Colors.black)),],)),
                                              //splashColor: Colors.brown,
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                              onPressed: () {
                                              signInWithGoogle().whenComplete(() {
                                                Navigator.of(context).push(
                                              //look up top for corrrection to get flow correctly
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return HomePage();
                                                },
                                              ),
                                            );
                                        }
                                        );
                                      },


                                            ),
                                          ),
                                  ),


                                  Positioned(
                                    bottom: 180,
                                    child:
                                    FlatButton(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(text: "Don't have an account? ", style: TextStyle(fontSize: 15, color: Color(0xFF442B2B), fontFamily: 'Montserrat',),),
                                            TextSpan(text: "Register here!", style: TextStyle(fontSize: 15, color: Color(0xFF442B2B), fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(context, "/register");
                                      },

                                    ),),


                                  ],

                                ),

                            )

                            ),
                              ),
                      ],
                      ),


    ),
                        ),

              
    );

  }

}