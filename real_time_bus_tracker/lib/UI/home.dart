import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Test'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text("Drawer"),
                decoration: BoxDecoration(
                    color: Colors.deepPurple),
              ),
              ListTile(
                title: Text('ITEM 1'), //add on-tap functions
              ),
              ListTile(
                title: Text('ITEM 2'), //add on-tap functions
              )
            ],
          ),
        ),
      ),
    );
  }
}