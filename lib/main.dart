import 'package:crudfirebase/telas/HomePage.dart';
import 'package:crudfirebase/telas/LoginPage.dart';
import 'package:crudfirebase/telas/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'GlobalState.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String testProviderText = "Olá Provider!";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<String>(create: (context) => testProviderText),
        StreamProvider<FirebaseUser>(create: (context) => FirebaseAuth.instance.onAuthStateChanged)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => HomePage(),
          '/sign_up': (context) => RegisterPage(),
        },
      ),
    );
  }
}
