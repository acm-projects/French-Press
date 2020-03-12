import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';




String _mapStyle;


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.uid}) : super(key: key); //update this to include the uid in the constructor

  final String title;

  final String uid; //include this

  @override

  _HomePageState createState() => _HomePageState();

}



class _HomePageState extends State<HomePage> {

  Stream<QuerySnapshot> _cafes;

  final Completer<GoogleMapController> _controller = Completer();

  FirebaseUser currentUser;

  BitmapDescriptor pinLocationIcon;



  @override

  void initState() {

    super.initState();

    this.getCurrentUser();



    _cafes= Firestore.instance

        .collection('cafes')

        .orderBy('address')

        .snapshots();

  }
  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text("French press"),
      ),

        floatingActionButton: Container(
           padding: EdgeInsets.only(top: 100.0,left:50),
           child: Align(alignment: Alignment.topLeft,



          child: FloatingActionButton(
             child: Text("Log Out"),
          onPressed: () {



            FirebaseAuth.instance
                .signOut()
                .then((result) =>
                Navigator.pushReplacementNamed(context, "/login"))
                .catchError((err) => print(err));

          },//on pressed
    )
           )






      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: _cafes,

        builder: (context, snapshot) {

          if (snapshot.hasError) {

            return Center(child: Text('Error: ${snapshot.error}'));

          }

          if (!snapshot.hasData) {

            return Center(child: const Text('Loading...'));

          }



          return Stack(

            children: <Widget>[

              MapPage(

                documents: snapshot.data.documents,

                initialPosition: const LatLng(32.7767, -96.7970),

                mapController: _controller,

              ),

              StoreCarousel(

                documents: snapshot.data.documents,

                mapController: _controller,

              ),

            ],

          );

        },

      ),

    );

  }

}
class StoreCarousel extends StatelessWidget {

  const StoreCarousel({

    Key key,

    @required this.documents,

    @required this.mapController,

  }) : super(key: key);



  final List<DocumentSnapshot> documents;

  final Completer<GoogleMapController> mapController;



  @override

  Widget build(BuildContext context) {

    return Align(

      alignment: Alignment.bottomLeft,

      child: Padding(

        padding: const EdgeInsets.only(bottom: 10),

        child: SizedBox(

          height: 90,

          child: ListView.builder(

            scrollDirection: Axis.horizontal,

            itemCount: documents.length,

            itemBuilder: (builder, index) {

              return SizedBox(

                width: 340,

                child: Padding(

                  padding: const EdgeInsets.only(left: 8),

                  child: Card(

                    child: Center(

                      child: StoreListTile(

                        document: documents[index],

                        mapController: mapController,

                      ),

                    ),

                  ),

                ),

              );

            },

          ),

        ),

      ),

    );

  }

}
class StoreListTile extends StatefulWidget {

  const StoreListTile({

    Key key,

    @required this.document,

    @required this.mapController,

  }) : super(key: key);



  final DocumentSnapshot document;

  final Completer<GoogleMapController> mapController;



  @override

  State<StatefulWidget> createState() {

    return _StoreListTileState();

  }

}

class _StoreListTileState extends State<StoreListTile> {

  String _placePhotoUrl = '';

  bool _disposed = false;



  @override

  void initState() {

    super.initState();

  }



  @override

  void dispose() {

    _disposed = true;

    super.dispose();

  }






  @override

  Widget build(BuildContext context) {


      return ListTile(

      title: Text(widget.document['name']),

      subtitle: Text(widget.document['address']),

      leading: Container(

        child: _placePhotoUrl.isNotEmpty

        // ? CircleAvatar(backgroundImage: NetworkImage(_placePhotoUrl))

            ? ClipRRect(

          child: Image.network(_placePhotoUrl, fit: BoxFit.cover),

          borderRadius: const BorderRadius.all(Radius.circular(2)),

        )

            : CircleAvatar(

          child: Icon(

            Icons.android,

            color: Colors.white,

          ),

          backgroundColor: Colors.pink,

        ),

        width: 100,

        height: 60,

      ),

      onTap: () async {


        final controller = await widget.mapController.future;

        await controller.animateCamera(

          CameraUpdate.newCameraPosition(

            CameraPosition(

              target: LatLng(

                widget.document['location'].latitude,

                widget.document['location'].longitude,

              ),

              zoom: 16,

            ),

          ),

        );

      },

    );


  }

}

class MapPage extends StatefulWidget {

  const MapPage({

    Key key,

    @required this.documents,

    @required this.initialPosition,

    @required this.mapController,

  }) : super(key: key);

  final List<DocumentSnapshot> documents;

  final LatLng initialPosition;

  final Completer<GoogleMapController> mapController;


  State<StatefulWidget> createState() => MapPageState();

}
// NEED MAP STYLE>>>>
class MapPageState extends State<MapPage> {

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor pinLocationIcon;

  @override

  void initState() {

    super.initState();

    rootBundle.loadString('assets/silverMap.txt').then((string) {

      _mapStyle = string;

    });

    setCustomMapPin();
    populateClients();


  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(

        ImageConfiguration(devicePixelRatio: 2.5),

        'assets/hehe.png');
  }

  LatLng pinPosition = LatLng(37.3797536, -122.1017334);

  void populateClients(){
   Firestore.instance

        .collection('cafes')

        .getDocuments()

        .then((docs){
          if(docs.documents.isNotEmpty){
            for(int i = 0; i <docs.documents.length; ++i)
              {
                initMarker(docs.documents[i].data, docs.documents[i].documentID);
              }
          }
   });

  }

  void initMarker(request, requestId)
  {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      icon: pinLocationIcon,
      markerId: markerId,
      position:
      LatLng(request['location'].latitude,request['location'].longitude),
      infoWindow: InfoWindow(

        title: request['name'],

        snippet: request['address'],

      ),

    );
    setState(() {
      markers[markerId] = marker;
      print(markerId);

    });
  }

  @override
  Widget build(BuildContext context) {

    return GoogleMap(

      initialCameraPosition: CameraPosition(

        zoom: 16,

        bearing: 30,
          target: pinPosition

      ),

      markers: Set<Marker>.of(markers.values),

      onMapCreated: (mapController) {
        mapController.setMapStyle(_mapStyle);

        this.widget.mapController.complete(mapController);

      },

    );

  }

}














