import 'package:frenchpress/cafe.dart';
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
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                  title: Text('ABOUT US', style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 3.0),),
                  onTap: () {
                    //shit don't do nothing yet
                    Navigator.pop(context);
                  }
              ),
              ListTile(
                title: Text('FAVORITES', style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 3.0),),
                onTap: () {
                  Navigator.pop(context);
                }
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: ListTile(
                  //shit don't do nothing yet
                  //will make settings page soon yah
                  //title: Icon(Icons.settings, color: Colors.black),
                  leading: Text('SETTINGS', style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 3.0),),
                onTap: () {
                    Navigator.pushNamed(context, "/settings");
                },
                ),
              ),
            ]

          ),
        )
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 8.0,
        centerTitle: true,
        title: Text('MAP', style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: 'Montserrat', letterSpacing: 3.0),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
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

      title: Text(widget.document['name'], style: TextStyle(fontFamily: "Montserrat", fontSize: 17.5)),

      subtitle: Text(widget.document['address'], style: TextStyle(fontFamily: "Montserrat", fontSize: 12.5)),

      leading: Container(

        child: _placePhotoUrl.isNotEmpty

        // ? CircleAvatar(backgroundImage: NetworkImage(_placePhotoUrl))

            ? ClipRRect(

          child: Image.network(_placePhotoUrl, fit: BoxFit.cover),

          borderRadius: const BorderRadius.all(Radius.circular(20.0)),

        )

            : CircleAvatar(

          child: Icon(

            Icons.location_on,

            color: Colors.black,

          ),

          backgroundColor: Colors.white,

        ),

        width: 50,

        height: 50,

      ),
      trailing: IconButton(
        onPressed: () {
           if(widget.document.documentID == "1418 Coffee House")
              Navigator.pushNamed(context, "/1418");
           else if (widget.document.documentID == "I Love U A-Latte")
             Navigator.pushNamed(context, "/iLove");
           else if (widget.document.documentID == "Merit Coffee Co.")
             Navigator.pushNamed(context, "/meritCoffee");
           else if (widget.document.documentID == "MudLeaf")
             Navigator.pushNamed(context, "/mudLeaf");
           else if (widget.document.documentID == "Murray Street Coffee Shop")
             Navigator.pushNamed(context, "/Murray");
           else if (widget.document.documentID == "Pearl Cup Coffee")
             Navigator.pushNamed(context, "/pearlCup");
           else if (widget.document.documentID == "White Rock Castle")
             Navigator.pushNamed(context, "/whiteRock");
        },
        icon: Icon(Icons.arrow_forward_ios, size: 15.0),

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

    rootBundle.loadString('assets/map.json').then((string) {
      _mapStyle = string;
    });

    setCustomMapPin();
    populateClients();
  }

  void setCustomMapPin() async {
    Icon(Icons.location_on);
    /*
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),

        'assets/AlexAssets/hehe.png');

     */
  }

  LatLng pinPosition = LatLng(37.3797536, -122.1017334);
  String travel;

  void populateClients() {
    Firestore.instance

        .collection('cafes')

        .getDocuments()

        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  void initMarker(request, requestId) {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      icon: pinLocationIcon,
      markerId: markerId,
      position:
      LatLng(request['location'].latitude, request['location'].longitude),
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

final PageController ctrl = PageController();
  class Fourteenpage extends StatelessWidget{

    @override
    Widget build(BuildContext context)
    {
      return MaterialApp(
          home: Scaffold(
            body:
            PageView(
              scrollDirection: Axis.horizontal,
              controller: ctrl,
              children: [
                Container(
                    color: Color(0xFFDBCFC7),
                    child:
                    Column(
                      children: <Widget> [
                        Padding(padding: const EdgeInsets.all(30.0), child: Container(alignment: Alignment.topLeft, child: SafeArea( child: Text('About the shop.',textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Inria_Serif", fontSize: 40, color: Color(0xFF442B2B)))))),
                        SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Container(
                                  alignment: Alignment.center,
                                  width: 350.0,
                                  height: 500.0,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)),color: Colors.white),
                                  child: Stack (children:
                                    <Widget> [
                                      StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                                          builder: (context, snapshot){
                                            if (!snapshot.hasData) return Text('Loading data');
                                            return
                                              ListView(
                                                children: <Widget>[
                                                  ListTile(
                                                      title: Text('AESTHETIC', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                      subtitle:
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(8),
                                                          child: Container(
                                                            height: 10,
                                                            child: LinearProgressIndicator(
                                                            value: (snapshot.data.documents[0]['aesthetic']/10.0),
                                                            backgroundColor: Color(0xFF442B2B),
                                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                                      ),
                                                          ),
                                                        ),
                                                  ),
                                                  ListTile(
                                                    title: Text('FOOD', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                    subtitle:
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Container(
                                                        height: 10,
                                                        child: LinearProgressIndicator(
                                                          value: (snapshot.data.documents[0]['food']/10.0),
                                                          backgroundColor: Color(0xFF442B2B),
                                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Text('QUALITY', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                    subtitle:
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Container(
                                                        height: 10,
                                                        child: LinearProgressIndicator(
                                                          value: (snapshot.data.documents[0]['quality']/10.0),
                                                          backgroundColor: Color(0xFF442B2B),
                                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Text('MEAL OPTIONS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                    trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                                  ),
                                                  ListTile(
                                                    title: Text('OUTLETS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                    trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                                  ),
                                                  ListTile(
                                                    title: Text('WIFI', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                    trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                                  ),
                                                  ListTile(
                                                    title: Text('SEATING', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                    trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                                  ),
                                                  ListTile(
                                                    title: Text('CHILL VIBES', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                    trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                                  ),
                                                ],
                                              );
                                          }
                                      ),
                                    ],

                                  ),
                              ),
                  ],

                              ),
                        ),

      ],
                    ),

      ),

                Container(
                  alignment: Alignment.center,
                  color: Color(0xFFDBCFC7),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text('Loading data');
                    return
                      SafeArea(
                        child: Container(
                          alignment: Alignment.center,
                          width: 350.0,
                          height: 300.0,
                          child: Text(snapshot.data.documents[0]['address'].toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF442B2B), fontSize: 40, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.white,
                          ),
                    ),
                      );

                  }
                  ),
                  ],
    ),
                  ),


    ],




          ),
          ),
      );
    }

  }
  class iLove extends StatelessWidget {
    @override
    Widget build(BuildContext context) { return MaterialApp(
        home: Scaffold(
            body: PageView(
                scrollDirection: Axis.horizontal,
                controller: ctrl,
                children: [
                  Container(
                    color: Color(0xFFDBCFC7),
                    child:
                    Column(
                      children: <Widget> [
                        Padding(padding: const EdgeInsets.all(30.0), child: Container(alignment: Alignment.topLeft, child: SafeArea( child: Text('About the shop.',textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Inria_Serif", fontSize: 40, color: Color(0xFF442B2B)))))),
                        SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Container(
                                alignment: Alignment.center,
                                width: 350.0,
                                height: 500.0,
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)),color: Colors.white),
                                child: Stack (children:
                                <Widget> [
                                  StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                                      builder: (context, snapshot){
                                        if (!snapshot.hasData) return Text('Loading data');
                                        return
                                          ListView(
                                            children: <Widget>[
                                              ListTile(
                                                title: Text('AESTHETIC', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                subtitle:
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Container(
                                                    height: 10,
                                                    child: LinearProgressIndicator(
                                                      value: (snapshot.data.documents[1]['aesthetic']/10.0),
                                                      backgroundColor: Color(0xFF442B2B),
                                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                title: Text('FOOD', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                subtitle:
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Container(
                                                    height: 10,
                                                    child: LinearProgressIndicator(
                                                      value: (snapshot.data.documents[1]['food']/10.0),
                                                      backgroundColor: Color(0xFF442B2B),
                                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                title: Text('QUALITY', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                subtitle:
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Container(
                                                    height: 10,
                                                    child: LinearProgressIndicator(
                                                      value: (snapshot.data.documents[1]['quality']/10.0),
                                                      backgroundColor: Color(0xFF442B2B),
                                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                title: Text('MEAL OPTIONS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                              ),
                                              ListTile(
                                                title: Text('OUTLETS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                              ),
                                              ListTile(
                                                title: Text('WIFI', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                              ),
                                              ListTile(
                                                title: Text('SEATING', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                              ),
                                              ListTile(
                                                title: Text('CHILL VIBES', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                                trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                              ),
                                            ],
                                          );
                                      }
                                  ),
                                ],

                                ),
                              ),
                            ],

                          ),
                        ),

                      ],
                    ),

                  ),

                  Container(
                    alignment: Alignment.center,
                    color: Color(0xFFDBCFC7),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Text('Loading data');
                            return
                              SafeArea(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 350.0,
                                  height: 300.0,
                                  child: Text(snapshot.data.documents[1]['address'].toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF442B2B), fontSize: 40, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.white,
                                  ),
                                ),
                              );

                          }
                      ),
                    ],
                    ),
                  ),


                ],


            )
        )

    );
    }
  }

  class meritCoffee extends StatelessWidget{
  @override
  Widget build(BuildContext context)
  {
  return Scaffold(
    body:
      PageView(
        scrollDirection: Axis.horizontal,
        controller: ctrl,
        children: [
          Container(
            color: Color(0xFFDBCFC7),
            child:
            Column(
              children: <Widget> [
                Padding(padding: const EdgeInsets.all(30.0), child: Container(alignment: Alignment.topLeft, child: SafeArea( child: Text('About the shop.',textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Inria_Serif", fontSize: 40, color: Color(0xFF442B2B)))))),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Container(
                        alignment: Alignment.center,
                        width: 350.0,
                        height: 500.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)),color: Colors.white),
                        child: Stack (children:
                        <Widget> [
                          StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                              builder: (context, snapshot){
                                if (!snapshot.hasData) return Text('Loading data');
                                return
                                  ListView(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('AESTHETIC', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        subtitle:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            height: 10,
                                            child: LinearProgressIndicator(
                                              value: (snapshot.data.documents[2]['aesthetic']/10.0),
                                              backgroundColor: Color(0xFF442B2B),
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                            ),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text('FOOD', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        subtitle:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            height: 10,
                                            child: LinearProgressIndicator(
                                              value: (snapshot.data.documents[2]['food']/10.0),
                                              backgroundColor: Color(0xFF442B2B),
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                            ),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text('QUALITY', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        subtitle:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            height: 10,
                                            child: LinearProgressIndicator(
                                              value: (snapshot.data.documents[2]['quality']/10.0),
                                              backgroundColor: Color(0xFF442B2B),
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                            ),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text('MEAL OPTIONS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                      ),
                                      ListTile(
                                        title: Text('OUTLETS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                      ),
                                      ListTile(
                                        title: Text('WIFI', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                      ),
                                      ListTile(
                                        title: Text('SEATING', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                      ),
                                      ListTile(
                                        title: Text('CHILL VIBES', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                      ),
                                    ],
                                  );
                              }
                          ),
                        ],

                        ),
                      ),
                    ],

                  ),
                ),

              ],
            ),

          ),

          Container(
            alignment: Alignment.center,
            color: Color(0xFFDBCFC7),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text('Loading data');
                    return
                      SafeArea(
                        child: Container(
                          alignment: Alignment.center,
                          width: 350.0,
                          height: 300.0,
                          child: Text(snapshot.data.documents[2]['address'].toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF442B2B), fontSize: 40, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.white,
                          ),
                        ),
                      );

                  }
              ),
            ],
            ),
          ),


        ],


      )
  );
  }

  }

  class mudLeaf extends StatelessWidget{
  @override
  Widget build(BuildContext context)
  {
  return Scaffold(
    body:
    PageView(
      scrollDirection: Axis.horizontal,
      controller: ctrl,
      children: [
        Container(
          color: Color(0xFFDBCFC7),
          child:
          Column(
            children: <Widget> [
              Padding(padding: const EdgeInsets.all(30.0), child: Container(alignment: Alignment.topLeft, child: SafeArea( child: Text('About the shop.',textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Inria_Serif", fontSize: 40, color: Color(0xFF442B2B)))))),
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Container(
                      alignment: Alignment.center,
                      width: 350.0,
                      height: 500.0,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)),color: Colors.white),
                      child: Stack (children:
                      <Widget> [
                        StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                            builder: (context, snapshot){
                              if (!snapshot.hasData) return Text('Loading data');
                              return
                                ListView(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('AESTHETIC', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                      subtitle:
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          height: 10,
                                          child: LinearProgressIndicator(
                                            value: (snapshot.data.documents[3]['aesthetic']/10.0),
                                            backgroundColor: Color(0xFF442B2B),
                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                          ),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text('FOOD', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                      subtitle:
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          height: 10,
                                          child: LinearProgressIndicator(
                                            value: (snapshot.data.documents[3]['food']/10.0),
                                            backgroundColor: Color(0xFF442B2B),
                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                          ),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text('QUALITY', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                      subtitle:
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          height: 10,
                                          child: LinearProgressIndicator(
                                            value: (snapshot.data.documents[2]['quality']/10.0),
                                            backgroundColor: Color(0xFF442B2B),
                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                          ),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text('MEAL OPTIONS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                      trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                    ),
                                    ListTile(
                                      title: Text('OUTLETS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                      trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                    ),
                                    ListTile(
                                      title: Text('WIFI', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                      trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                    ),
                                    ListTile(
                                      title: Text('SEATING', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                      trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                    ),
                                    ListTile(
                                      title: Text('CHILL VIBES', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                      trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                    ),
                                  ],
                                );
                            }
                        ),
                      ],

                      ),
                    ),
                  ],

                ),
              ),

            ],
          ),

        ),

        Container(
          alignment: Alignment.center,
          color: Color(0xFFDBCFC7),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text('Loading data');
                  return
                    SafeArea(
                      child: Container(
                        alignment: Alignment.center,
                        width: 350.0,
                        height: 300.0,
                        child: Text(snapshot.data.documents[3]['address'].toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF442B2B), fontSize: 40, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.white,
                        ),
                      ),
                    );

                }
            ),
          ],
          ),
        ),


      ],




    ),
  );
  }

  }

  class Murray extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body:
        PageView(
          scrollDirection: Axis.horizontal,
          controller: ctrl,
          children: [
            Container(
              color: Color(0xFFDBCFC7),
              child:
              Column(
                children: <Widget> [
                  Padding(padding: const EdgeInsets.all(30.0), child: Container(alignment: Alignment.topLeft, child: SafeArea( child: Text('About the shop.',textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Inria_Serif", fontSize: 40, color: Color(0xFF442B2B)))))),
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Container(
                          alignment: Alignment.center,
                          width: 350.0,
                          height: 500.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)),color: Colors.white),
                          child: Stack (children:
                          <Widget> [
                            StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                                builder: (context, snapshot){
                                  if (!snapshot.hasData) return Text('Loading data');
                                  return
                                    ListView(
                                      children: <Widget>[
                                        ListTile(
                                          title: Text('AESTHETIC', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          subtitle:
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              height: 10,
                                              child: LinearProgressIndicator(
                                                value: (snapshot.data.documents[4]['aesthetic']/10.0),
                                                backgroundColor: Color(0xFF442B2B),
                                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                              ),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text('FOOD', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          subtitle:
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              height: 10,
                                              child: LinearProgressIndicator(
                                                value: (snapshot.data.documents[4]['food']/10.0),
                                                backgroundColor: Color(0xFF442B2B),
                                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                              ),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text('QUALITY', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          subtitle:
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              height: 10,
                                              child: LinearProgressIndicator(
                                                value: (snapshot.data.documents[4]['quality']/10.0),
                                                backgroundColor: Color(0xFF442B2B),
                                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                              ),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text('MEAL OPTIONS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                        ),
                                        ListTile(
                                          title: Text('OUTLETS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                        ),
                                        ListTile(
                                          title: Text('WIFI', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                        ),
                                        ListTile(
                                          title: Text('SEATING', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                        ),
                                        ListTile(
                                          title: Text('CHILL VIBES', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                        ),
                                      ],
                                    );
                                }
                            ),
                          ],

                          ),
                        ),
                      ],

                    ),
                  ),

                ],
              ),

            ),

            Container(
              alignment: Alignment.center,
              color: Color(0xFFDBCFC7),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text('Loading data');
                      return
                        SafeArea(
                          child: Container(
                            alignment: Alignment.center,
                            width: 350.0,
                            height: 300.0,
                            child: Text(snapshot.data.documents[4]['address'].toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF442B2B), fontSize: 40, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.white,
                            ),
                          ),
                        );

                    }
                ),
              ],
              ),
            ),


          ],




        ),
      );
    }
  }

  class pearlCup extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body:
        PageView(
          scrollDirection: Axis.horizontal,
          controller: ctrl,
          children: [
            Container(
              color: Color(0xFFDBCFC7),
              child:
              Column(
                children: <Widget> [
                  Padding(padding: const EdgeInsets.all(30.0), child: Container(alignment: Alignment.topLeft, child: SafeArea( child: Text('About the shop.',textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Inria_Serif", fontSize: 40, color: Color(0xFF442B2B)))))),
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Container(
                          alignment: Alignment.center,
                          width: 350.0,
                          height: 500.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)),color: Colors.white),
                          child: Stack (children:
                          <Widget> [
                            StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                                builder: (context, snapshot){
                                  if (!snapshot.hasData) return Text('Loading data');
                                  return
                                    ListView(
                                      children: <Widget>[
                                        ListTile(
                                          title: Text('AESTHETIC', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          subtitle:
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              height: 10,
                                              child: LinearProgressIndicator(
                                                value: (snapshot.data.documents[5]['aesthetic']/10.0),
                                                backgroundColor: Color(0xFF442B2B),
                                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                              ),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text('FOOD', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          subtitle:
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              height: 10,
                                              child: LinearProgressIndicator(
                                                value: (snapshot.data.documents[5]['food']/10.0),
                                                backgroundColor: Color(0xFF442B2B),
                                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                              ),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text('QUALITY', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          subtitle:
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              height: 10,
                                              child: LinearProgressIndicator(
                                                value: (snapshot.data.documents[5]['quality']/10.0),
                                                backgroundColor: Color(0xFF442B2B),
                                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                              ),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text('MEAL OPTIONS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                        ),
                                        ListTile(
                                          title: Text('OUTLETS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                        ),
                                        ListTile(
                                          title: Text('WIFI', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                        ),
                                        ListTile(
                                          title: Text('SEATING', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                        ),
                                        ListTile(
                                          title: Text('CHILL VIBES', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                          trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                        ),
                                      ],
                                    );
                                }
                            ),
                          ],

                          ),
                        ),
                      ],

                    ),
                  ),

                ],
              ),

            ),

            Container(
              alignment: Alignment.center,
              color: Color(0xFFDBCFC7),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text('Loading data');
                      return
                        SafeArea(
                          child: Container(
                            alignment: Alignment.center,
                            width: 350.0,
                            height: 300.0,
                            child: Text(snapshot.data.documents[5]['address'].toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF442B2B), fontSize: 40, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.white,
                            ),
                          ),
                        );

                    }
                ),
              ],
              ),
            ),


          ],




        ),
      );
    }
  }

  class whiteRock extends StatelessWidget{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body:
      PageView(
        scrollDirection: Axis.horizontal,
        controller: ctrl,
        children: [
          Container(
            color: Color(0xFFDBCFC7),
            child:
            Column(
              children: <Widget> [
                Padding(padding: const EdgeInsets.all(30.0), child: Container(alignment: Alignment.topLeft, child: SafeArea( child: Text('About the shop.',textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Inria_Serif", fontSize: 40, color: Color(0xFF442B2B)))))),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Container(
                        alignment: Alignment.center,
                        width: 350.0,
                        height: 500.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)),color: Colors.white),
                        child: Stack (children:
                        <Widget> [
                          StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                              builder: (context, snapshot){
                                if (!snapshot.hasData) return Text('Loading data');
                                return
                                  ListView(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('AESTHETIC', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        subtitle:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            height: 10,
                                            child: LinearProgressIndicator(
                                              value: (snapshot.data.documents[1]['aesthetic']/10.0),
                                              backgroundColor: Color(0xFF442B2B),
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                            ),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text('FOOD', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        subtitle:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            height: 10,
                                            child: LinearProgressIndicator(
                                              value: (snapshot.data.documents[2]['food']/10.0),
                                              backgroundColor: Color(0xFF442B2B),
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                            ),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text('QUALITY', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        subtitle:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            height: 10,
                                            child: LinearProgressIndicator(
                                              value: (snapshot.data.documents[1]['quality']/10.0),
                                              backgroundColor: Color(0xFF442B2B),
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDBCFC7)),

                                            ),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text('MEAL OPTIONS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                      ),
                                      ListTile(
                                        title: Text('OUTLETS', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                      ),
                                      ListTile(
                                        title: Text('WIFI', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                      ),
                                      ListTile(
                                        title: Text('SEATING', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                      ),
                                      ListTile(
                                        title: Text('CHILL VIBES', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                                        trailing: Icon(Icons.check, color: Color(0xFF442B2B)),

                                      ),
                                    ],
                                  );
                              }
                          ),
                        ],

                        ),
                      ),
                    ],

                  ),
                ),

              ],
            ),

          ),

          Container(
            alignment: Alignment.center,
            color: Color(0xFFDBCFC7),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              StreamBuilder(stream: Firestore.instance.collection('cafes').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text('Loading data');
                    return
                      SafeArea(
                        child: Container(
                          alignment: Alignment.center,
                          width: 350.0,
                          height: 300.0,
                          child: Text(snapshot.data.documents[6]['address'].toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF442B2B), fontSize: 40, fontFamily: 'Montserrat', letterSpacing: 2.0),),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.white,
                          ),
                        ),
                      );

                  }
              ),
            ],
            ),
          ),


        ],




      ),
    );
  }
  }



  class SettingsPage extends StatefulWidget {

  SettingsPage({Key key}) : super(key: key);



  @override

  _SettingsPageState createState() => _SettingsPageState();

  }

  class _SettingsPageState extends State<SettingsPage>{
    FirebaseUser CurrentUser;
    @override
    bool DarkModeSwitch = false;
    bool LightModeSwitch = false;
    void initState(){
      super.initState();
  }

  @override
  Widget build(BuildContext context){
      return Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            color: Color(0xFFDBCFC7),
            child: Column( children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(text: "Settings.", style: TextStyle(fontFamily: "Inria_Serif", fontSize: 50, fontWeight: FontWeight.bold, color: Color(0xFF442B2B)),
                    ),
                  ),
                ),
              ),
              Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              width: 350.0,
              height: 250.0,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)),color: Colors.white),
              child: Stack(
                children: <Widget> [

                  ListView(children: [
                    SwitchListTile(
                      title: const Text('DARK MODE', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 3.0),),
                      value: DarkModeSwitch,
                      onChanged: (value){
                        setState((){
                          DarkModeSwitch = value;
                          print(DarkModeSwitch);
                        });
                      },
                        activeTrackColor: Color(0xFFDBCFC7),
                        activeColor: Colors.brown,
                      ),
                    SwitchListTile(
                      title: const Text('LIGHT MODE', style: TextStyle(color: Color(0xFF442B2B), fontSize: 20, fontFamily: 'Montserrat', letterSpacing: 3.0),),
                      value: LightModeSwitch,
                      onChanged: (value){
                        setState((){
                          LightModeSwitch = value;
                          print(LightModeSwitch);
                        });
                      },
                      activeTrackColor: Color(0xFFDBCFC7),
                      activeColor: Colors.brown,
                    ),


      ] ,

                  scrollDirection: Axis.vertical,
                ),
            ],



                ),
      ),
              RaisedButton(
                  child: RichText(
                      text: TextSpan(text: 'LOGOUT', style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Montserrat', letterSpacing: 3.0),)),
                  color: Colors.brown,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

                  onPressed: (){
                    FirebaseAuth.instance
                        .signOut()
                        .then((result) =>
                        Navigator.pushReplacementNamed(context, "/login"))
                        .catchError((err) => print(err));
                  }
              ),

          ],

            ),
          ),
        )
      );
  }
}
















