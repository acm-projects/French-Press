
import 'package:flutter/material.dart';

import 'register.dart';

import 'splash.dart';

import 'login.dart';

import 'home.dart';



void main() => runApp(MyApp());



class MyApp extends StatelessWidget {

  // This widget is the root of your application.

  @override

  Widget build(BuildContext context) {

    return MaterialApp(

        title: 'COFFE APP',

        theme: ThemeData(

          primarySwatch: Colors.green,

        ),

        home: SplashPage(),

        routes: <String, WidgetBuilder>{

          '/home': (BuildContext context) => MapPage(title: 'Home'),

          '/login': (BuildContext context) => LoginPage(),

          '/register': (BuildContext context) => RegisterPage(),

        });

  }

}