import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:trash_finder/auth/login.dart';

class ConfigurationsPage extends StatefulWidget {
  @override
  _ConfigurationsPageState createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future _logout(BuildContext context) async {
    await auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginPage()), (route) => false);
  }

  var _formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? telefone, dataNasc;

  Future _update(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Adiciona o apelido no firestore (database):
        firestore.collection('users').doc(auth.currentUser?.uid).update({
          'telefone': telefone,
          'dataNasc': dataNasc,
          'data': DateTime.now()
        });
      } on FirebaseAuthException catch (ex) {
        print(ex.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Card(
              shadowColor: Colors.green[400],
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      // initialValue: auth.currentUser,
                      decoration: InputDecoration(
                        labelText: "Telefone",
                      ),
                      onSaved: (value) => telefone = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Data de nascimento",
                      ),
                      onSaved: (value) => dataNasc = value,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green[400]),
                          onPressed: () => _update(context),
                          child: Text("Alterar"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green[400]),
              onPressed: () => _logout(context),
              child: Text("Sair"),
            ),
          ),
        ),
      ],
    );
  }
}
