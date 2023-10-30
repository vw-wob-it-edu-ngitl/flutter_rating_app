// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ratings_page.dart';


class RatingAppModel extends ChangeNotifier {

  RatingAppModel(){
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    var prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch(e) {
      SharedPreferences.setMockInitialValues({
        'rating_timeout': 2000
      });
      prefs = await SharedPreferences.getInstance();
    }
    _ratingTimeout = prefs.getInt('rating_timeout') ?? 0;
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('rating_timeout', _ratingTimeout);
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
    notifyListeners();
  }

  int getPin() => _pin;

  bool _loggedIn = false;
  Map<Rating, int> _ratings = {};
  int _ratingTimeout = 0;
  int _pin = 0000;

}
