import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class DriverHome extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return(MaterialApp(
      home: Scaffold(
        body: Map(),
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {
              FirebaseAuth.instance.signOut(),
              Navigator.pop(context)
            },
          ),
        ),
      ),
    ));
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
  GeoPoint currentLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _updateUserLocation();
  }
  void _updateUserLocation() async {
   /* StreamSubscription stream =*/ Geolocator().getPositionStream().listen((Position position) {
      currentLocation = GeoPoint(position.latitude, position.longitude);
      print('location: $currentLocation');
      db.collection('UserLocation')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        "Location": currentLocation
      });
    });
    // stream.cancel();
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
            // markers: _markers,

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
            myLocationButtonEnabled: false,
          ),
        ]),
      ),
    );
  }
}