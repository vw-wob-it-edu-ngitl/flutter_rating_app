// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:flutter_rating_app/database_interface.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'rating.dart';


final log = Logger('APP_MODEL');


class Rating {

  const Rating({
    this.id,
    required this.ratingValue,
    required this.dateTime,
  });

  Rating.fromMap(Map<String, dynamic> map) :
    id = map['id'] as int,
    ratingValue = RatingValue.values[map['ratingValue'] as int],
    dateTime = DateTime.parse(map['dateTime'] as String);

  final int? id;
  final RatingValue ratingValue;
  final DateTime dateTime;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ratingValue': ratingValue.index,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  @override
  String toString() => 'id=$id, ratingValue=$ratingValue, dateTime=$dateTime';

}


class RatingAppModel extends ChangeNotifier {

  Future<void> init() async {
    await _loadSettings();
    await _loadRatings();
    await _loadRatingsMetaData();
  }

  Future<SharedPreferences> _initSharedPreferences() async {
    var prefs;
    try {
      log.info('Loading shared preferences.');
      prefs = await SharedPreferences.getInstance();
    } catch(e) {
      const defaultSettings = {
        'locale': 'en',
        'rating_timeout': 2000,
        'pin': "0000"
      };
      log.warning('Init of SharedPreferences failed! Most likely because your on a development environment.');
      log.warning('Loading default settings: $defaultSettings');
      SharedPreferences.setMockInitialValues(defaultSettings);
      prefs = await SharedPreferences.getInstance();
    }
    return prefs;
  }

  Future<void> _loadSettings() async {
    var prefs = await _initSharedPreferences();
    _locale = prefs.getString('locale') ?? 'de';
    _ratingTimeout = prefs.getInt('rating_timeout') ?? 2000;
    _pin = prefs.getInt('pin') ?? 0;
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', _locale);
    prefs.setInt('rating_timeout', _ratingTimeout);
    prefs.setInt('pin', _pin);
    log.info('Saved settings.');
    notifyListeners();
  }

  Future<void> _loadRatings() async {
    await _databaseInterface.open();
    var ratings = await _databaseInterface.getRatings();

    for (var rating in ratings) {
      _ratings.update(
        rating.ratingValue,
            (value) => ++value,
        ifAbsent: () => 1,
      );
    }

    notifyListeners();
  }

  Future<void> _loadRatingsMetaData() async {
    _oldestRatingDateTime = await _databaseInterface.getOldestRatingDateTime();
    _latestRatingDateTime = await _databaseInterface.getLatestRatingDateTime();

    notifyListeners();
  }

  void addRating(RatingValue rating) {
    _ratings.update(
      rating,
          (value) => ++value,
      ifAbsent: () => 1,
    );
    notifyListeners();

    _databaseInterface.insertRating(Rating(ratingValue: rating, dateTime: DateTime.now()));
    _loadRatingsMetaData();
  }

  int getRating(RatingValue rating) => _ratings[rating] ?? 0;

  void clearRatings() {
    for (final rating in RatingValue.values) {
      _ratings[rating] = 0;
    }
    notifyListeners();

    _databaseInterface.clearRatings();
    _loadRatingsMetaData();
  }

  int getTotalNumberOfRatings() {
    var totalNumberOfRating = 0;
    for(var ratings in _ratings.values) {
      totalNumberOfRating += ratings;
    }
    return totalNumberOfRating;
  }

  DateTime? getOldestRatingDateTime() => _oldestRatingDateTime;
  DateTime? getLatestRatingDateTime() => _latestRatingDateTime;

  int getRatingTimeout() => _ratingTimeout;

  void setRatingTimeout(int ratingTimeout) {
    _ratingTimeout = ratingTimeout;
    _saveSettings();
  }

  void login() {
    _loggedIn = true;
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    notifyListeners();
  }

  bool isLoggedIn() => _loggedIn;

  void setPin(int pin) {
    _pin = pin;
    _saveSettings();
  }

  int getPin() => _pin;

  void setLocale(String locale) {
    _locale = locale;
    notifyListeners();
  }

  String getLocale() => _locale;

  bool _loggedIn = false;
  final Map<RatingValue, int> _ratings = {};
  DateTime? _oldestRatingDateTime;
  DateTime? _latestRatingDateTime;
  int _ratingTimeout = 0;
  int _pin = 0000;
  String _locale = 'en';

  final DatabaseInterface _databaseInterface = DatabaseInterface();

}
