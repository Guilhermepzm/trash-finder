import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

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

  final _trashTitles = {
    "none": Text(
      'Lixeira Regular',
    ),
  };

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
          children: [
            Card(
              shadowColor: Colors.green[400],
              margin: new EdgeInsets.only(bottom: 20),
              child: InkWell(
                splashColor: Colors.green[400],
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.trash_fill,
                          color: Colors.green[400],
                          size: 36,
                        ),
                        title: _trashTitles[trash['type']],
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                trash['description'],
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            Text(
                              (trash['distance'] / 1000).toStringAsFixed(1) +
                                  ' km',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: SizedBox(
                          width: double.infinity,
                          height: 140,
                          child: Container(
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              MapsLauncher.launchCoordinates(
                                  trash['lat'], trash['long']);
                            },
                            icon: Icon(
                              Icons.map_sharp,
                              color: Colors.green[400],
                            ),
                            label: const Text(
                              'ABRIR NO MAPS',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
