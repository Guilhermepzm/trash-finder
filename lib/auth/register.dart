import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../app/home.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var _formKey = GlobalKey<FormState>();

  String? nome, email, senha, apelido;

  Future _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await auth.createUserWithEmailAndPassword(
            email: email!, password: senha!);

        await auth.currentUser?.updateDisplayName(nome);

        // Adiciona o apelido no firestore (database):
        firestore
            .collection('users')
            .doc(auth.currentUser?.uid)
            .set({'apelido': apelido, 'data': DateTime.now()});

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
      } on FirebaseAuthException catch (ex) {
        print(ex.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Registro"),
        backgroundColor: Colors.green[400],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nome",
                ),
                onSaved: (value) => nome = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "E-mail",
                ),
                onSaved: (value) => email = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Senha",
                ),
                obscureText: true,
                onSaved: (value) => senha = value,
                validator: (value) {
                  if (value!.length < 6)
                    return "Senha deve conter no mínimo 6 caracteres";
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Apelido",
                ),
                onSaved: (value) => apelido = value,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green[400]),
                  onPressed: () => _register(context),
                  child: Text("Registrar"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
