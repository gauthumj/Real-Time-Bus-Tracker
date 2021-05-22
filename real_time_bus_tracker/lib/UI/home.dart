import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'dart:async';
import './login.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
final geo = Geoflutterfire();

class Home extends StatelessWidget {
  final GeoPoint geoPoint = GeoPoint(0,0);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
            top: 0,
            bottom: 150,
            left: 0,
            right: 0,
            child: Container(
              child: Map(),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.25,
              minChildSize: 0.1,
              maxChildSize: 0.75,
              builder: (BuildContext context, ScrollController scrollController){
                return Container(
                  color: Colors.white,
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(title : Text('Item $index'),);
                      }),
                );
              },
            )
          ],
        ),
        appBar: AppBar(
          title: Text('Bus Tracker'),
        ),
        drawer: Drawer(
          child: Column(
            children:  <Widget>[
              Container(
                height: 130.0,
                child: DrawerHeader(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                         "Profile",
                         style: TextStyle(
                           fontSize: 18,
                           fontWeight: FontWeight.bold,
                         ),
                      ),
                      Icon(Icons.account_circle_outlined),
                    ]
                  ),
                  decoration: BoxDecoration(color: Colors.deepPurple),
                ),
              ),
              ListTile(
                title: Text(
                    'Settings',
                    style: TextStyle(fontSize: 16)

                ),
                onTap: () =>{},
                leading: Icon(Icons.settings),
              ),
              ListTile(
                title: Text(
                    'About',
                    style: TextStyle(fontSize: 16)
                ),
                leading: Icon(Icons.people), //add on-tap functions
              ),
              Expanded(child: Container()),
              Card(
              child: ListTile(
                title: Text(
                  'Log Out',
                  style: TextStyle(fontSize:16)
                ),
                onTap: () => {
                  handleSignOut(),
                  Navigator.pop(context)
              },//add on-tap functions
                leading: Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> controller1 = Completer();

  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  static LatLng _lastMapPosition = _initialPosition;
  GeoPoint geoPoint;
  int _markerIdCounter=0;


  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getDriverLocation();
  }

  void _setMarkers(LatLng point) async{
      final String markerIdVal = 'marker_id:$_markerIdCounter';
      _markers.clear();
      _markerIdCounter++;
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(markerIdVal),
            position: point
          ),
        );
      });
  }

  void _getDriverLocation() async{

    await db.collection('UserLocation').doc('U6PG3P3oChRJHr03xoVLKJjRLF83').get().then((value) => {
                      geoPoint = value.data().values.first,
                      print(geoPoint.latitude)
                    });

    Stream<List<DocumentSnapshot>> stream = geo.collection(collectionRef:db.collection('UserLocation')).data('1');
    stream.listen((List<DocumentSnapshot> documentList) {
      // _markers.clear();
      geoPoint= documentList.elementAt(0).data().values.first; //elementAt(busNo - 1)
      LatLng pos = LatLng(geoPoint.latitude, geoPoint.longitude);
      print('position: $pos');
      _setMarkers(pos);
    });
    LatLng pos = LatLng(geoPoint.latitude, geoPoint.longitude);
    print('position: $pos');
    _markers.add(
      Marker(markerId: MarkerId('1'),position: pos)
    );
    // _setMarkers(pos);
  }


  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
              title: "Pizza Parlour",
              snippet: "This is a snippet",
              onTap: () {}),
          onTap: () {},
          icon: BitmapDescriptor.defaultMarker));
    });
  }


  Widget mapButton(Function function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition == null
          ? Container(
              child: Center(
                child: Text(
                  'loading map..',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
              ),
            )
          : Container(
              child: Stack(children: <Widget>[
                GoogleMap(
                  markers:_markers,
                  mapType: _currentMapType,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 14.4746,
                  ),
                  onMapCreated: _onMapCreated,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ]),
            ),
    );
  }
}
