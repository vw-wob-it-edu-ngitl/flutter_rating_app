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


class EmojiButton extends StatefulWidget {
  EmojiButton({
    super.key,
    required this.rating,
    required this.onClicked
  });

  EmojiButton.veryLow({super.key, required this.onClicked}) :
        rating = Rating.veryLow;

  EmojiButton.low({super.key, required this.onClicked}) :
        rating = Rating.low;

  EmojiButton.medium({super.key, required this.onClicked}) :
        rating = Rating.medium;

  EmojiButton.high({super.key, required this.onClicked}) :
        rating = Rating.high;

  EmojiButton.veryHigh({super.key, required this.onClicked}) :
        rating = Rating.veryHigh;

  final Rating rating;

  final void Function(Rating) onClicked;

  @override
  State<EmojiButton> createState() => _EmojiButtonState();

  static String getAssetNameByRating(rating) {
    switch (rating) {
      case Rating.veryLow:
        return 'assets/images/svg/ratings/ratings_very_low.svg';
      case Rating.low:
        return 'assets/images/svg/ratings/ratings_low.svg';
      case Rating.medium:
        return 'assets/images/svg/ratings/ratings_medium.svg';
      case Rating.high:
        return 'assets/images/svg/ratings/ratings_high.svg';
      case Rating.veryHigh:
        return 'assets/images/svg/ratings/ratings_very_high.svg';
      default:
        throw UnimplementedError("Rating $rating is unknown");
    }
  }
}

class _EmojiButtonState extends State<EmojiButton> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation positionAnimation;
  late Animation opacityAnimation;

  @override
  void initState() {
    super.initState();
    controller =  AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
      animationBehavior: AnimationBehavior.preserve,
    );
    positionAnimation = Tween<AlignmentDirectional>(
      begin: AlignmentDirectional.center,
      end: AlignmentDirectional.topCenter,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.slowMiddle
    ));
    opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutQuint
    ));

    controller.addListener(() {
      setState(() {
      });
      if (controller.isCompleted) {
        controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var assetName = EmojiButton.getAssetNameByRating(widget.rating);

    return Expanded(
      child: Stack(
        children:
          [
            Container(
              alignment: positionAnimation.value,
              child: Opacity(
                opacity: opacityAnimation.value,
                child: const Text(
                  '+1',
                  style: TextStyle(fontSize: 32.0,fontWeight: FontWeight.bold),),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onClicked(widget.rating);
                if (controller.isAnimating) {
                  controller.reset();
                }
                controller.forward();
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
          ]
      ),
    );
  }
}