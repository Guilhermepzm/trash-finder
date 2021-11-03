import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trash_finder/app/trash/register.dart';

class AddButtonPage extends StatefulWidget {
  @override
  _AddButtonPageState createState() => _AddButtonPageState();
}

class _AddButtonPageState extends State<AddButtonPage> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterPage()),
        );
      },
      child: const Icon(Icons.add),
      backgroundColor: Colors.green[400],
    );
  }
}
