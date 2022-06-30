import 'package:flutter/material.dart';
import 'package:prova1/pages/sensorPage.dart';
import 'package:prova1/pages/homePage.dart';
import 'package:prova1/pages/showDatabase.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  List pages = [HomePage(), const ShowDatabase(), SensorPage()];

  int _currIndex = 0;
  void onTap(index) {
    setState(() {
      _currIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: pages[_currIndex],
        bottomNavigationBar: BottomNavigationBar(
          unselectedFontSize: 0,
          selectedFontSize: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blueGrey,
          onTap: onTap,
          currentIndex: _currIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white.withOpacity(0.2),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(label: 'home', icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                label: 'dataB', icon: Icon(Icons.fitness_center)),
            BottomNavigationBarItem(label: 'base', icon: Icon(Icons.bar_chart)),
          ],
        ));
  }
}
