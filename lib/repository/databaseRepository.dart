import 'package:flutter/material.dart';
import 'package:prova1/database/entities/series.dart';

import '../database/database.dart';

class DatabaseRepository extends ChangeNotifier {
  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

  //This method wraps the findAllSeries() method of the DAO
  Future<List<Series>> findAllSeries() async {
    final results = await database.seriesDao.findAllSeries();
    return results;
  } //findAllSeries

  //This method wraps the insertSeries() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> insertSeries(Series series) async {
    await database.seriesDao.insertSeries(series);
    notifyListeners();
  } //insertSeries

  //This method wraps the deleteSeries() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> removeSeries(Series series) async {
    await database.seriesDao.deleteSeries(series);
    notifyListeners();
  } //removeSeries

} //DatabaseRepository
