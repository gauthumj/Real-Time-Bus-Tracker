import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class Login extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Login'),),
        body: TextButton(
          child: Text('Login with google'),
          onPressed: ()async{
            _handleSignIn();
            Navigator.pushNamed(context, '/home');
            },
        )
     ),
      );
  }
}