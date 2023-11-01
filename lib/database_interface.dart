// Copyright (C) 2023 twyleg
import 'dart:io';
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'rating_app_model.dart';

final log = Logger('DATABASE_INTERFACE');


class DatabaseInterface {

  late Database _database;
  static const _databaseFilename = 'ratings_database.db';

  DatabaseInterface({databaseFilename = _databaseFilename}) {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<String> getDatabaseFilepath() async {
    return join(await getDatabasesPath(), _databaseFilename);
  }

  Future<void> deleteDatabase() async {
    var databaseFilepath = await getDatabaseFilepath();
    log.info('Deleting database: $databaseFilepath');
    var databaseFile = File(databaseFilepath);
    if (await databaseFile.exists()) {
      await databaseFile.delete();
    }
  }

  Future<void> open() async {
    var path = await getDatabaseFilepath();

    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        log.info('Creating database.');
        return db.execute(
          'CREATE TABLE ratings(id INTEGER PRIMARY KEY, ratingValue INTEGER, dateTime STRING)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertRating(Rating rating) async {
    final db = _database;

    await db.insert(
      'ratings',
      rating.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> clearRatings() async {
    await _database.delete('ratings');
  }

  Future<List<Rating>> getRatings() async {
    final List<Map<String, dynamic>> maps = await _database.query('ratings');
    return List.generate(maps.length, (i) => Rating.fromMap(maps[i]));
  }

  Future<DateTime> getOldestRatingDateTime() async {
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT * FROM ratings ORDER BY dateTime ASC LIMIT 1'
    );

    return DateTime.parse(maps[0]['dateTime'] as String);
  }

  Future<DateTime> getLatestRatingDateTime() async {
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT * FROM ratings ORDER BY dateTime DESC LIMIT 1'
    );

    return DateTime.parse(maps[0]['dateTime'] as String);
  }

}