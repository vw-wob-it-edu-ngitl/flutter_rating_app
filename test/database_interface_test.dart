// Copyright (C) 2023 twyleg
import 'package:flutter_rating_app/database_interface.dart';
import 'package:flutter_rating_app/rating_app_model.dart';
import 'package:flutter_rating_app/rating.dart';
import 'package:test/test.dart';

void main() async {

  late DatabaseInterface databaseInterface;

  Rating prepareRating(RatingValue ratingValue, {String dateTimeString = "2023-01-01T00:00+00:00"}) => Rating(
      ratingValue: RatingValue.veryHigh,
      dateTime: DateTime.parse(dateTimeString)
  );

  Future<void> expectNumberOfRatings(int expectedNumberOfRatings) async {
    var ratings = await databaseInterface.getRatings();
    expect(ratings.length, expectedNumberOfRatings);
  }

  setUp(() async {
    databaseInterface = DatabaseInterface(databaseFilename: 'test_rating_database.db');
    databaseInterface.deleteDatabase();
    await databaseInterface.open();
  });

  test('DatabaseEmpty AddSingleRating SingleRatingInDatabase', () async {
    final rating = prepareRating(RatingValue.veryHigh);

    await databaseInterface.insertRating(rating);

    await expectNumberOfRatings(1);
  });

  test('DatabaseEmpty AddMultipleRatings MultipleRatingsInDatabase', () async {
    final rating = prepareRating(RatingValue.veryHigh);

    await databaseInterface.insertRating(rating);
    await databaseInterface.insertRating(rating);

    await expectNumberOfRatings(2);
  });

  test('DatabaseEmpty AddRatingsWithDifferentValue RatingsWithAllValuesInDatabase', () async {
    await databaseInterface.insertRating(prepareRating(RatingValue.veryHigh));
    await databaseInterface.insertRating(prepareRating(RatingValue.high));
    await databaseInterface.insertRating(prepareRating(RatingValue.medium));
    await databaseInterface.insertRating(prepareRating(RatingValue.low));
    await databaseInterface.insertRating(prepareRating(RatingValue.veryLow));

    // await expectNumberOfRatings(2);
  });

  test('DatabaseWithRatingsWithDifferentDateTimes GetOldestRatingsDateTime OldestRatingsDateTimeReturned', () async {
    await databaseInterface.insertRating(prepareRating(RatingValue.veryHigh, dateTimeString: '2023-01-01T00:01+00:00'));
    await databaseInterface.insertRating(prepareRating(RatingValue.veryHigh, dateTimeString: '2023-01-01T00:02+00:00'));
    await databaseInterface.insertRating(prepareRating(RatingValue.veryHigh, dateTimeString: '2023-01-01T00:03+00:00'));

    expect(await databaseInterface.getOldestRatingDateTime(), DateTime.parse('2023-01-01T00:01+00:00'));
  });

  test('DatabaseWithRatingsWithDifferentDateTimes GetLatestRatingsDateTime LatestRatingsDateTimeReturned', () async {
    await databaseInterface.insertRating(prepareRating(RatingValue.veryHigh, dateTimeString: '2023-01-01T00:01+00:00'));
    await databaseInterface.insertRating(prepareRating(RatingValue.veryHigh, dateTimeString: '2023-01-01T00:02+00:00'));
    await databaseInterface.insertRating(prepareRating(RatingValue.veryHigh, dateTimeString: '2023-01-01T00:03+00:00'));

    expect(await databaseInterface.getLatestRatingDateTime(), DateTime.parse('2023-01-01T00:03+00:00'));
  });
}