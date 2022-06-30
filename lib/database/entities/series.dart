import 'package:floor/floor.dart';

// create entity Series that will collect all our information
// about every series
@entity
class Series {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int? reps; // number of reps for each series
  final double meanAcc; // mean acceleration of the series
  final double? meanTime; // mean time for one reps in the series
  //Default constructor
  Series(this.id, this.reps, this.meanAcc, this.meanTime);
}
