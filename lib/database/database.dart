//Imports that are necessary to the code generator of floor
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:prova1/database/daos/seriesDao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

//Here, we are importing the entities and the daos of the database
import 'entities/series.dart';

//The generated code will be in database.g.dart
part 'database.g.dart';

//Here we are saying that this is the first version of the Database and it has just 1 entity
@Database(version: 1, entities: [Series])
abstract class AppDatabase extends FloorDatabase {
  //Add all the daos as getters here
  SeriesDao get seriesDao;
}//AppDatabase