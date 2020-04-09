import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';



class RegisterPage extends StatefulWidget {

  RegisterPage({Key key}) : super(key: key);



  @override

  _RegisterPageState createState() => _RegisterPageState();

}



class _RegisterPageState extends State<RegisterPage> {

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  TextEditingController firstNameInputController;

  TextEditingController lastNameInputController;

  TextEditingController emailInputController;

  TextEditingController pwdInputController;

  TextEditingController confirmPwdInputController;



  @override

  initState() {

    firstNameInputController = new TextEditingController();

    lastNameInputController = new TextEditingController();

    emailInputController = new TextEditingController();

    pwdInputController = new TextEditingController();

    confirmPwdInputController = new TextEditingController();

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

        /*appBar: AppBar(

          title: Text("Register"),

        ),*/

        body: Container(

            alignment: Alignment.center,
            padding: const EdgeInsets.all(15.0),
            color: Color(0xFFDBCFC7),

              child: Container(

                child: SingleChildScrollView(

                    child: Column(

                      children: <Widget>[
                        //Image.asset('assets/AlexAssets/logo.png'),
                        SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              alignment: Alignment.topLeft,
                              child: RichText(text: TextSpan(text: 'Sign up ',
                                  style: TextStyle(fontFamily: 'Inria_Serif', fontSize: 40, fontWeight: FontWeight.normal, color: Color(0xFF442B2B)),
                                  children: <TextSpan> [
                                    TextSpan(text: 'here.', style: TextStyle(fontFamily: 'Inria_Serif', fontSize: 40, fontWeight: FontWeight.bold),),
                                  ]),),
                            ),
                        ),
                      ),

                      Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.all(8.0),
                        width: 350.0,
                        height: 615.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)),color: Colors.white),
                        child: Form(

                          key: _registerFormKey,

                          child: SafeArea(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(

                                      decoration: InputDecoration(
                                          fillColor: Color(0xFF442B2B),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Color(0xFFDBCFC7))),
                                          labelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Color(0xFF442B2B)),
                                          labelText: 'First Name*',),
                                      controller: firstNameInputController,
                                      validator: (value) {
                                        if (value.length < 3) {

                                          return "Please enter a valid first name.";

                                        }

                                      },

                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(

                                        decoration: InputDecoration(
                                            fillColor: Color(0xFF442B2B),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Color(0xFFDBCFC7))),
                                            labelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Color(0xFF442B2B)),
                                            labelText: 'Last Name*',),

                                        controller: lastNameInputController,

                                        validator: (value) {

                                          if (value.length < 3) {

                                            return "Please enter a valid last name.";

                                          }

                                        }),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),

                                    child: TextFormField(

                                      decoration: InputDecoration(
                                          fillColor: Color(0xFF442B2B),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Color(0xFFDBCFC7))),
                                          labelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Color(0xFF442B2B)),
                                          labelText: 'Email*',),

                                      controller: emailInputController,

                                      keyboardType: TextInputType.emailAddress,

                                      validator: emailValidator,

                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(

                                      decoration: InputDecoration(
                                          fillColor: Color(0xFF442B2B),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Color(0xFFDBCFC7))),
                                          labelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Color(0xFF442B2B)),
                                          labelText: 'Password*',),
                                      controller: pwdInputController,

                                      obscureText: true,

                                      validator: pwdValidator,

                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(

                                      decoration: InputDecoration(
                                          fillColor: Color(0xFF442B2B),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Color(0xFFDBCFC7))),
                                          labelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Color(0xFF442B2B)),
                                          labelText: 'Confirm Password*',),

                                      controller: confirmPwdInputController,

                                      obscureText: true,

                                      validator: pwdValidator,

                                    ),
                                  ),



                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(

                                      child: RichText(
                                          text: TextSpan(text: 'SIGN UP', style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'Montserrat', letterSpacing: 3.0),)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),

                                      color: Colors.brown,

                                      textColor: Colors.white,

                                      onPressed: () {

                                        if (_registerFormKey.currentState.validate()) {

                                          if (pwdInputController.text ==

                                              confirmPwdInputController.text) {

                                            FirebaseAuth.instance

                                                .createUserWithEmailAndPassword(

                                                email: emailInputController.text,

                                                password: pwdInputController.text)

                                                .then((currentUser) => Firestore.instance

                                                .collection("users")

                                                .document(currentUser.uid)

                                                .setData({

                                              "uid": currentUser.uid,

                                             // "fname": firstNameInputController.text,

                                              "surname": lastNameInputController.text,

                                              "email": emailInputController.text,

                                            })

                                                .then((result) => {

                                              Navigator.pushAndRemoveUntil(

                                                  context,

                                                  MaterialPageRoute(

                                                      builder: (context) => HomePage(

                                                        title:

                                                       "coffe",

                                                        uid: currentUser.uid,

                                                      )),

                                                      (_) => false),

                                              firstNameInputController.clear(),

                                              lastNameInputController.clear(),

                                              emailInputController.clear(),

                                              pwdInputController.clear(),

                                              confirmPwdInputController.clear()

                                            })

                                                .catchError((err) => print(err)))

                                                .catchError((err) => print(err));

                                          } else {

                                            showDialog(

                                                context: context,

                                                builder: (BuildContext context) {

                                                  return AlertDialog(

                                                    title: Text("Error"),

                                                    content: Text("The passwords do not match"),

                                                    actions: <Widget>[

                                                      FlatButton(

                                                        child: Text("Close"),

                                                        onPressed: () {

                                                          Navigator.of(context).pop();

                                                        },

                                                      )

                                                    ],

                                                  );

                                                });

                                          }

                                        }

                                      },

                                    ),
                                  ),






                                ],

                              ),

                          ),

                        ),
                      ),

                        FlatButton(

                          child: Text("Already have an account? Login here!", style: TextStyle(color: Color(0xFF442B2B), fontFamily: 'Montserrat', fontWeight: FontWeight.bold,)),

                          onPressed: () {

                            Navigator.pop(context);

                          },

                        ),
                    ],)),
              ),
            ));

  }

}