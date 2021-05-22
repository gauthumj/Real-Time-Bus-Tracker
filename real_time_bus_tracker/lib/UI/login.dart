import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

Future<void> _handleSignIn() async{
  try{
    await _googleSignIn.signIn();
  }
  catch(error) {
    print(error);
  }
}

handleSignOut() async => _googleSignIn.disconnect();

class Login extends StatelessWidget {
  // const Login({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Tabbar(),
    );
  }
}

class Tabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/UI/images/back_2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              height:300,
              width: 400,
              child: Card(
                child:
                DefaultTabController(
                  length: 2,
                  child: Column( children: <Widget>[
                    Container(
                      height: 60,
                      child: TabBar(
                        labelColor: Colors.indigo,
                        unselectedLabelColor: Colors.indigo,
                        indicatorColor: Colors.blueGrey,
                        indicatorWeight: 2,
                        tabs: <Widget>[
                          Tab(text: "STUDENT LOGIN", icon: Icon(Icons.person)),
                          Tab(text: "DRIVER LOGIN", icon: Icon(Icons.airport_shuttle_rounded)),
                        ],
                      ),
                    ),
                    Container(
                      height:200,
                      child: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(75.0),
                            child: GoogleSignInButton(
                              onPressed: ()async{
                                _handleSignIn();
                                Navigator.pushNamed(context, '/home');
                              },
                              darkMode: true,
                            ),
                          ),
                          MyCustomForm(),
                        ],
                      ),
                    ),
                  ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Username",
                fillColor: Colors.white,
                contentPadding: new EdgeInsets.fromLTRB(0,8.0,8.0,0),
                focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
                fillColor: Colors.white,
                contentPadding: new EdgeInsets.fromLTRB(0,8.0,8.0,0),
                focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}