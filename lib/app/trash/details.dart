import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrashDetailsPage extends StatefulWidget {
  const TrashDetailsPage({Key? key, required this.trash}) : super(key: key);

  // Declare a field that holds the Todo.
  final Map trash;
  @override
  _TrashDetailsPageState createState() => _TrashDetailsPageState(trash);
}

class _TrashDetailsPageState extends State<TrashDetailsPage> {
  _TrashDetailsPageState(this.trash);
  final Map trash;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text("Detalhes"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
