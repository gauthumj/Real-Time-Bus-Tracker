import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Base',
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
                  color: Colors.deepPurple
                ),
              ),
              ListTile(
                title: Text('ITEM 1'),        //add on-tap functions
              ),
              ListTile(
                title: Text('ITEM 2'),        //add on-tap functions
              )
            ],
          ),
        ),

      ),

    );
  }
}