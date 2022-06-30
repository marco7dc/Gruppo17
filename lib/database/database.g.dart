// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SeriesDao? _seriesDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Series` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `reps` INTEGER, `meanAcc` REAL NOT NULL, `meanTime` REAL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SeriesDao get seriesDao {
    return _seriesDaoInstance ??= _$SeriesDao(database, changeListener);
  }
}

class _$SeriesDao extends SeriesDao {
  _$SeriesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _seriesInsertionAdapter = InsertionAdapter(
            database,
            'Series',
            (Series item) => <String, Object?>{
                  'id': item.id,
                  'reps': item.reps,
                  'meanAcc': item.meanAcc,
                  'meanTime': item.meanTime
                }),
        _seriesDeletionAdapter = DeletionAdapter(
            database,
            'Series',
            ['id'],
            (Series item) => <String, Object?>{
                  'id': item.id,
                  'reps': item.reps,
                  'meanAcc': item.meanAcc,
                  'meanTime': item.meanTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Series> _seriesInsertionAdapter;

  final DeletionAdapter<Series> _seriesDeletionAdapter;

  @override
  Future<List<Series>> findAllSeries() async {
    return _queryAdapter.queryList('SELECT * FROM Series',
        mapper: (Map<String, Object?> row) => Series(
            row['id'] as int?,
            row['reps'] as int?,
            row['meanAcc'] as double,
            row['meanTime'] as double?));
  }

  @override
  Future<void> insertSeries(Series series) async {
    await _seriesInsertionAdapter.insert(series, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSeries(Series task) async {
    await _seriesDeletionAdapter.delete(task);
  }
}
