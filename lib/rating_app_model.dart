// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ratings_page.dart';


final log = Logger('APP_MODEL');


class RatingAppModel extends ChangeNotifier {

  RatingAppModel(){
    _loadSettings();
  }

  Future<SharedPreferences> _initSharedPreferences() async {
    var prefs;
    try {
      log.info('Loading shared preferences.');
      prefs = await SharedPreferences.getInstance();
    } catch(e) {
      const defaultSettings = {
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
    _ratingTimeout = prefs.getInt('rating_timeout') ?? 0;
    _pin = prefs.getInt('pin') ?? 0;
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('rating_timeout', _ratingTimeout);
    prefs.setInt('pin', _pin);
    log.info('Saved settings.');
    notifyListeners();
  }

  void addRating(Rating rating) {
    _ratings.update(
      rating,
          (value) => ++value,
      ifAbsent: () => 1,
    );
    notifyListeners();
  }

  int getRating(Rating rating) {
    return _ratings[rating] ?? 0;
  }

  void clearRatings() {
    for (final rating in Rating.values) {
      _ratings[rating] = 0;
    }
    notifyListeners();
  }

  int getRatingTimeout() {
    return _ratingTimeout;
  }

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

  bool _loggedIn = false;
  Map<Rating, int> _ratings = {};
  int _ratingTimeout = 0;
  int _pin = 0000;

}
