import 'package:crudfirebase/models/Post.dart';
import 'package:flutter/material.dart';

class PostsShowPage extends StatefulWidget {
  PostsShowPage({Key key, @required this.post}) : super(key: key);
  final Post post;

  @override
  _PostsShowPageState createState() => _PostsShowPageState();
}
class _PostsShowPageState extends State<PostsShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts Show"),
      ),
      body: Center(
        // https://stackoverflow.com/questions/51579546/how-to-format-datetime-in-flutter
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("O título é ... ${widget.post.title}"), // https://stackoverflow.com/questions/50818770/passing-data-to-a-stateful-widget
              Text("Criado em: ${widget.post.createdAt.toDate()}"), // If you need format date => https://stackoverflow.com/questions/51579546/how-to-format-datetime-in-flutter
            ],
          )
      ),
    );
  }
}