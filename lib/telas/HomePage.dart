import 'package:crudfirebase/widgets/HomeDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // final bool isAuthenticated = Provider.of<GlobalState>(context).isAuthenticated;
    final user = Provider.of<FirebaseUser>(context);
    final bool isAuthenticated = user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pagina inicial"),
      ),
      drawer: HomeDrawer(),
      body: Center(
          child: isAuthenticated
              ? Text('Página inicial após o login')
              : Text('Página inicial antes do login')),
    );
  }
}
