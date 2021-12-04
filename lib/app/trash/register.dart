import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var _formKey = GlobalKey<FormState>();

  String? description, lat, long;

  final _controllerLat = TextEditingController();
  final _controllerLong = TextEditingController();

  @override
  void dispose() {
    // other dispose methods
    _controllerLat.dispose();
    _controllerLong.dispose();
    super.dispose();
  }

  Future _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        firestore.collection('trash-list').add({
          'description': description,
          'lat': double.parse(lat ?? '0'),
          'long': double.parse(long ?? '0'),
          'created_at': DateTime.now(),
          "type": 'none',
        });
        Navigator.pop(context);
      } on FirebaseAuthException catch (ex) {
        print(ex.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Geolocator.getCurrentPosition().then((value) {
      setState(() {
        _controllerLat.text = value.latitude.toString();
        _controllerLong.text = value.longitude.toString();
      });
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text("Registro"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Descrição",
                ),
                onSaved: (value) => description = value,
                validator: (value) {
                  if (value!.length == 0) return "Campo requirido";
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerLat,
                decoration: InputDecoration(
                  labelText: "Latitude",
                ),
                onSaved: (value) => lat = value,
                validator: (value) {
                  if (value!.length == 0) return "Campo requirido";
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerLong,
                decoration: InputDecoration(
                  labelText: "Logintude",
                ),
                onSaved: (value) => long = value,
                validator: (value) {
                  if (value!.length == 0) return "Campo requirido";
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green[400]),
                  onPressed: () => _register(context),
                  child: Text("Salvar"),
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
