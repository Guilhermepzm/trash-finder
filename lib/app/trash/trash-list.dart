import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  shadowColor: Colors.green[400],
                  margin: new EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    splashColor: Colors.green[400],
                    onTap: () {
                      print(data);
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
                            subtitle: Text(
                              data['description'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
