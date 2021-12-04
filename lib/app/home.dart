import 'package:flutter/cupertino.dart';
import 'package:trash_finder/app/configurations/configurations.dart';
import 'package:trash_finder/app/maps/maps.dart';
import 'package:flutter/material.dart';
import 'package:trash_finder/app/trash/add-button.dart';
import 'package:trash_finder/app/trash/list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    TrashListPage(),
    MapsPage(),
    ConfigurationsPage()
  ];

  static List<Widget> _widgetTitles = <Widget>[
    Text(
      'Lixeiras',
    ),
    Text(
      'Home',
    ),
    Text(
      'Configurações',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: _widgetTitles.elementAt(_selectedIndex),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: Visibility(
        visible: _selectedIndex == 0,
        child: AddButtonPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.trash_fill),
            label: 'Lixeiras',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear_solid),
            label: 'Configurações',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.green[400],
        onTap: _onItemTapped,
      ),
    );
  }
}
