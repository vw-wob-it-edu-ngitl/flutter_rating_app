// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';

enum RatingValue {
  veryLow,
  low,
  medium,
  high,
  veryHigh
}

Color getRatingColor(RatingValue ratingValue) {
  switch (ratingValue) {
    case RatingValue.veryLow:
      return Colors.red;
    case RatingValue.low:
      return Colors.deepOrangeAccent;
    case RatingValue.medium:
      return Colors.yellow;
    case RatingValue.high:
      return Colors.lightGreenAccent;
    case RatingValue.veryHigh:
      return Colors.green;

  }
}

String getAssetNameByRating(rating) {
  switch (rating) {
    case RatingValue.veryLow:
      return 'assets/images/svg/ratings/ratings_very_low.svg';
    case RatingValue.low:
      return 'assets/images/svg/ratings/ratings_low.svg';
    case RatingValue.medium:
      return 'assets/images/svg/ratings/ratings_medium.svg';
    case RatingValue.high:
      return 'assets/images/svg/ratings/ratings_high.svg';
    case RatingValue.veryHigh:
      return 'assets/images/svg/ratings/ratings_very_high.svg';
    default:
      throw UnimplementedError("Rating $rating is unknown");
  }
}