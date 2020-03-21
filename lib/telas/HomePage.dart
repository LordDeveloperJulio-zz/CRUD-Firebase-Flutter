import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudfirebase/models/Post.dart';
import 'package:crudfirebase/widgets/HomeDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'LoginPage.dart';
import 'PostsNewPage.dart';
import 'PostsShowPage.dart';

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
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collectionGroup('posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Carregando...');
            default:
              return ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  final post = Post.fromFirestore(document);
                  return ListTile(
                    title: Text(
                      post.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(post.content),
                    onTap: () {
                      // https://flutter.dev/docs/cookbook/navigation/passing-data#4-navigate-and-pass-data-to-the-detail-screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostsShowPage(post: post),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isAuthenticated) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostsNewPage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        },
        tooltip: 'Nova Postagem',
        child: Icon(Icons.note_add),
      ),
    );
  }
}
