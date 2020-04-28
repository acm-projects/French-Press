
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
          '/1418': (BuildContext context) => Fourteenpage(),
          '/Murray': (BuildContext context) => Murray(),
          '/iLove': (BuildContext context) => iLove(),
          '/meritCoffee': (BuildContext context) => meritCoffee(),
          '/pearlCup': (BuildContext context) => pearlCup(),
          '/whiteRock': (BuildContext context) => whiteRock(),
          '/mudLeaf': (BuildContext context) => mudLeaf(),


        });

  }

}