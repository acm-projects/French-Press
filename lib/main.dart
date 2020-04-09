
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

        title: 'COFFEE APP',

        theme: ThemeData(

          primarySwatch: Colors.grey,

        ),

        home: SplashPage(),

        routes: <String, WidgetBuilder>{

          '/home': (BuildContext context) => HomePage(),

          '/login': (BuildContext context) => LoginPage(),

          '/register': (BuildContext context) => RegisterPage(),

          //'/settings': (BuildContext context) => SettingsPage(),
          //'/blackForest': (BuildContext context) => blackForest(),
          //'/1418': (BuildContext context) => 1418page(),
          //'/cafeBrazil': (BuildContext context) => cafeBrazil(),
          //'/houndstooth': (BuildContext context) => houndstooth(),
          //'/iLove': (BuildContext context) => iLove(),
          //'/meritCoffee': (BuildContext context) => meritCoffee(),
          //'/pearlCup': (BuildContext context) => pearlCup(),
          //'/whiteRock': (BuildContext context) => whiteRock(),


        });

  }

}