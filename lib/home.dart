import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'Login.dart';

String _mapStyle;


class MapPage extends StatefulWidget {
  MapPage({Key key, this.title, this.uid}) : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  State<StatefulWidget> createState() => MapPageState();

}

class MapPageState extends State<MapPage> {

  FirebaseUser currentUser;

  BitmapDescriptor pinLocationIcon;

  Set<Marker> _markers = {};

  Completer<GoogleMapController> _controller = Completer();


  @override
  void initState() {

    super.initState();

    rootBundle.loadString('assets/silverMap.txt').then((string) {
      _mapStyle = string;
    });

    setCustomMapPin();
    this.getCurrentUser();

    super.initState();

  }

  void getCurrentUser() async {

    currentUser = await FirebaseAuth.instance.currentUser();

  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(

        ImageConfiguration(devicePixelRatio: 2.5),

        'assets/hehe.png');
  }


  LatLng pinPosition = LatLng(37.3797536, -122.1017334);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(


              floatingActionButton: FloatingActionButton(

                child: Text("Log Out"),
                onPressed: () {

                  FirebaseAuth.instance

                      .signOut()

                      .then((result) =>

                      Navigator.pushReplacementNamed(context, "/login"))

                      .catchError((err) => print(err));

                },

              ),

          // floatingActionButton: FloatingActionButton(
           // onPressed: ()  => Navigator.pop(context),
          //),



          body: Stack(
            children: <Widget>[
              //Container(
              new GoogleMap(
                initialCameraPosition: CameraPosition(
                    zoom: 16,
                    bearing: 30,
                    target: pinPosition
                ),

                myLocationEnabled: true,

                compassEnabled: true,

                markers: _markers,


                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(_mapStyle);

                  _controller.complete(controller);

                  setState(() {
                    _markers.add(

                        Marker(

                          markerId: MarkerId('<MARKER_ID>'),

                          position: pinPosition,

                          icon: pinLocationIcon,

                          onTap: () {
                            SnackBar(content: Text("Marker Tapped!!"),);

                          },
                        )
                    );
                  },
                  );
                },
              ),


              // ),
            ],

          )

      ),

    );


  }
}
