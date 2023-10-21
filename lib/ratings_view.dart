// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum Rating {veryLow, low, medium, high, veryHigh}

class RatingView extends StatelessWidget {
  const RatingView({
    super.key,
    required this.onRating
  });

  final void Function(Rating) onRating;

  void buttonCallback(Rating rating) {
    onRating(rating);
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          EmojiButton.veryLow(onClicked: buttonCallback),
          SizedBox(width: 10),
          EmojiButton.low(onClicked: buttonCallback),
          SizedBox(width: 10),
          EmojiButton.medium(onClicked: buttonCallback),
          SizedBox(width: 10),
          EmojiButton.high(onClicked: buttonCallback),
          SizedBox(width: 10),
          EmojiButton.veryHigh(onClicked: buttonCallback),
        ],
      ),
    );
  }
}


class EmojiButton extends StatelessWidget {
  const EmojiButton({
    super.key,
    required this.rating,
    required this.onClicked
  });

  const EmojiButton.veryLow({super.key, required this.onClicked}) :
        rating = Rating.veryLow;

  const EmojiButton.low({super.key, required this.onClicked}) :
        rating = Rating.low;

  const EmojiButton.medium({super.key, required this.onClicked}) :
        rating = Rating.medium;

  const EmojiButton.high({super.key, required this.onClicked}) :
        rating = Rating.high;

  const EmojiButton.veryHigh({super.key, required this.onClicked}) :
        rating = Rating.veryHigh;

  final Rating rating;

  final void Function(Rating) onClicked;

  @override
  Widget build(BuildContext context) {
    var assetName = getAssetNameByRating(rating);
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          onClicked(rating);
          },

        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
        ),

        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SvgPicture.asset(
              assetName,
              semanticsLabel: 'A red up arrow',
              fit: BoxFit.contain
          ),
        ),
      ),
    );
  }

  static String getAssetNameByRating(rating) {
    switch (rating) {
      case Rating.veryLow:
        return 'assets/images/svg/emoji.svg';
      case Rating.low:
        return 'assets/images/svg/emoji.svg';
      case Rating.medium:
        return 'assets/images/svg/emoji.svg';
      case Rating.high:
        return 'assets/images/svg/emoji.svg';
      case Rating.veryHigh:
        return 'assets/images/svg/emoji.svg';
      default:
        throw UnimplementedError("Rating $rating is unknown");
    }
  }
}