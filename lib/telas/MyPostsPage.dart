import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudfirebase/models/Post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'PostsShowPage.dart';

class MyPostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Postagens'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("users")
            .document(user.uid)
            .collection("posts")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Carregando...');
            default:
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  final post = Post.fromFirestore(document);

                  return ListTile(
                    title: Text(
                      post.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(post.content),
                    trailing: PopupMenuButton(
                      onSelected: (result) async {
                        final type = result["type"];
                        final post = result["value"];
                        switch (type) {
                          case 'edit':
                            print('clique em editar');
                            break;
                          case 'delete':
                            await Firestore.instance
                                .collection('users')
                                .document(user.uid)
                                .collection('posts')
                                .document(post.id)
                                .delete();
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          value: {"type": "edit", "value": post},
                          child: Text('Editar'),
                        ),
                        PopupMenuItem(
                          value: {"type": "delete", "value": post},
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                    onTap: () {
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
    );
  }
}
