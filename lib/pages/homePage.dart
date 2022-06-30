import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// this page it's a simple welcome page
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        title: const Text('HOME'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('BENVENUTO DARTAGNAN',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 20),
          Icon(
            Icons.person,
            size: 100,
          )
        ],
      )),
    );
  }
}
