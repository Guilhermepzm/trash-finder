import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:trash_finder/app/trash/details.dart';

class TrashListPage extends StatefulWidget {
  @override
  _TrashListPageState createState() => _TrashListPageState();
}

class _TrashListPageState extends State<TrashListPage> {
  final Stream<QuerySnapshot> _trashStream =
      FirebaseFirestore.instance.collection('trash-list').snapshots();

  final _trashTitles = {
    "none": Text(
      'Lixeira Regular',
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Align(
        alignment: Alignment.topCenter,
        child: StreamBuilder<QuerySnapshot>(
          stream: _trashStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Align(
                alignment: Alignment.center,
                child: Center(child: Text("Something went wrong")),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Align(
                alignment: Alignment.center,
                child: Center(
                    child: CupertinoActivityIndicator(
                  radius: 20,
                )),
              );
            }

            var list = Future.wait(snapshot.data!.docs.map((e) async {
              Map<String, dynamic> data = e.data()! as Map<String, dynamic>;
              await Geolocator.getCurrentPosition().then((value) {
                data['distance'] = Geolocator.distanceBetween(
                    value.latitude, value.longitude, data['lat'], data['long']);
              });
              return data;
            }).toList());

            return FutureBuilder(
              builder: (context, projectSnap) {
                if (projectSnap.data == null) {
                  //print('project snapshot data is: ${projectSnap.data}');
                  return Align(
                    alignment: Alignment.center,
                    child: Center(
                        child: CupertinoActivityIndicator(
                      radius: 20,
                    )),
                  );
                }
                var temp = projectSnap.data as List;

                return ListView.builder(
                  itemCount: temp.length,
                  itemBuilder: (context, index) {
                    var temp = projectSnap.data as List;
                    temp.sort((a, b) => a['distance'].compareTo(b['distance']));
                    var data = temp[index];
                    return Card(
                      shadowColor: Colors.green[400],
                      margin: new EdgeInsets.only(bottom: 20),
                      child: InkWell(
                        splashColor: Colors.green[400],
                        onLongPress: () {
                          MapsLauncher.launchCoordinates(
                              data['lat'], data['long']);
                        },
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => TrashDetailsPage(
                                    trash: data,
                                  )));
                        },
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
                                title: _trashTitles[data['type']],
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        data['description'],
                                        maxLines: 2,
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                    ),
                                    Text(
                                      (data['distance'] / 1000)
                                              .toStringAsFixed(1) +
                                          ' km',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              future: list,
            );
          },
        ),
      ),
    );
  }
}
