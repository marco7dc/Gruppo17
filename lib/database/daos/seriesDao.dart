import 'package:floor/floor.dart';
import 'package:prova1/database/entities/series.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class SeriesDao {
  //Query #1: SELECT -> this allows to obtain all the entries of the Series table
  @Query('SELECT * FROM Series')
  Future<List<Series>> findAllSeries();

  //Query #2: INSERT -> this allows to add a Series in the table
  @insert
  Future<void> insertSeries(Series series);

  //Query #3: DELETE -> this allows to delete a Series from the table
  @delete
  Future<void> deleteSeries(Series task);
}//SeriesDao