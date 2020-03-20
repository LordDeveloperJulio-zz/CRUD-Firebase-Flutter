import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../GlobalState.dart';
import 'LoginPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // dispose() is lifecycle method of flutter
  // https://stackoverflow.com/questions/41479255/life-cycle-in-flutter
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
    // The purpose of calling dispose => Prevent memory leaks
    // https://stackoverflow.com/questions/59558604/why-do-we-use-dispose-method-in-dart-code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _registerFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration:
                    InputDecoration(labelText: 'Nome', hintText: "Julio"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Digite o seu nome.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email', hintText: "julio@example.com"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite o seu email';
                  } else if (!EmailValidator.validate(value)) {
                    // Use plugin https://pub.dev/packages/email_validator
                    // If you don't want to use plugin https://stackoverflow.com/questions/16800540/validate-email-address-in-dart
                    return 'Digite um email válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite a senha';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true,
                validator: (value) {
                  // https://stackoverflow.com/questions/50155348/how-to-validate-a-form-field-based-on-the-value-of-the-other
                  if (value != _passwordController.text) {
                    return 'A senha não corresponde';
                  }
                  return null;
                },
              ),
              Container(
                // https://stackoverflow.com/questions/50186555/how-to-set-margin-for-a-button-in-flutter
                margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: RaisedButton(
                  child: Text("Registrar"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (_registerFormKey.currentState.validate()) {
                      try {
                        // Register user by firebase auth
                        final FirebaseUser user = (await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text))
                            .user;

                        /* store users data in firestore database */
                        await Firestore.instance
                            .collection("users")
                            .document(user.uid)
                            .setData({
                          "name": _nameController.text,
                          "email": _emailController.text,
                          "createdAt": FieldValue.serverTimestamp(),
                          // https://stackoverflow.com/questions/50907151/flutter-firestore-server-side-timestamp
                          "updatedAt": FieldValue.serverTimestamp()
                        });

                        Navigator.pushNamed(context, '/');
                      } catch (e) {
                        print('Error Happened!!!: $e');
                      }
                    }
                  },
                ),
              ),
              Text("já tem uma conta?"),
              FlatButton(
                child: Text("Entre aqui!"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
