import 'package:flutter/material.dart';
import 'package:prova1/pages/loginPage.dart';
import 'package:prova1/pages/sensorPage.dart';
import 'package:prova1/pages/chartPage.dart';
import 'package:prova1/pages/homePage.dart';
import 'package:prova1/pages/showDatabase.dart';
import 'package:provider/provider.dart';

import 'package:prova1/pages/tabPage.dart';
import 'package:prova1/repository/databaseRepository.dart';

import 'database/database.dart';

Future<void> main() async {
  //This is a special method that use WidgetFlutterBinding to interact with the Flutter engine.
  //This is needed when you need to interact with the native core of the app.
  //Here, we need it since when need to initialize the DB before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  //This opens the database.
  final AppDatabase database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //This creates a new DatabaseRepository from the AppDatabase instance just initialized
  final databaseRepository = DatabaseRepository(database: database);

  //Here, we run the app and we provide to the whole widget tree the instance of the DatabaseRepository.
  //That instance will be then shared through the platform and will be unique.
  runApp(ChangeNotifierProvider<DatabaseRepository>(
    create: (context) => databaseRepository,
    child: const MainPage(),
  ));
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginPage(),
        'tab': (context) => const TabPage(),
        'sensor': (context) => SensorPage(),
        'chart': (context) => ChartPage(Chart: const []),
        'home': (context) => HomePage(),
        'dataB': (context) => const ShowDatabase(),
      },
    );
  }
}
