import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'RegisterPage.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _loginFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email', hintText: "julio@example.com"),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite o seu email';
                  } else if (!EmailValidator.validate(value)) {
                    return 'Digite um email válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                controller: _passwordController,
                obscureText: true,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Digite a sua senha';
                  }
                  return null;
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: RaisedButton(
                  child: Text("Login"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (_loginFormKey.currentState.validate()) {
                      try {
                        final FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        )).user;
                        Navigator.pushNamed(context, '/');
                      } catch (e) {
                        print('Ocorreu um erro!!!: $e');
                      }
                    }
                  },
                ),
              ),
              Text("Você não tem uma conta?"),
              FlatButton(
                child: Text("Registre-se aqui!"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}