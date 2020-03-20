import 'package:crudfirebase/telas/LoginPage.dart';
import 'package:crudfirebase/telas/MyPostsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final bool isAuthenticated = user != null;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              '${Provider.of<String>(context)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          if (isAuthenticated) ...[
            ListTile(
                leading: Icon(Icons.note),
                title: Text('Minhas postagens'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPostsPage()),
                  );
                }),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
          if (!isAuthenticated) ...[
            ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Conecte-se'),
                onTap: () {
                  // https://flutter.dev/docs/cookbook/navigation/navigation-basics#2-navigate-to-the-second-route-using-navigatorpush
                  // https://stackoverflow.com/questions/43807184/how-to-close-scaffolds-drawer-after-an-item-tap
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Cadastre-se'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/sign_up');
                }),
          ],
        ],
      ),
    );
  }
}
