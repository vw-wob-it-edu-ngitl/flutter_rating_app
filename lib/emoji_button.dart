// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'screens/ratings_screen.dart';
import 'rating.dart';

class EmojiButton extends StatefulWidget {
  const EmojiButton({
    super.key,
    this.caption = "",
    required this.rating,
    required this.onClicked
  });

  const EmojiButton.veryLow({super.key, this.caption = "", required this.onClicked}) :
        rating = RatingValue.veryLow;

  const EmojiButton.low({super.key, this.caption = "", required this.onClicked}) :
        rating = RatingValue.low;

  const EmojiButton.medium({super.key, this.caption = "", required this.onClicked}) :
        rating = RatingValue.medium;

  const EmojiButton.high({super.key, this.caption = "", required this.onClicked}) :
        rating = RatingValue.high;

  const EmojiButton.veryHigh({super.key, this.caption = "", required this.onClicked}) :
        rating = RatingValue.veryHigh;

  final RatingValue rating;
  final String caption;

  final void Function(BuildContext, RatingValue) onClicked;

  @override
  State<EmojiButton> createState() => _EmojiButtonState();

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
      duration: const Duration(milliseconds: 2000),
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
    var assetName = getAssetNameByRating(widget.rating);

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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: Provider.of<RatingsViewModel>(context, listen: true).enabled ? () {
                    widget.onClicked(context, widget.rating);
                    if (controller.isAnimating) {
                      controller.reset();
                    }
                    controller.forward();
                  } : null,

                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder()
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                      // width: double.infinity,
                      // height: double.infinity,
                      aspectRatio: 1,
                      child: SvgPicture.asset(
                          assetName,
                          fit: BoxFit.contain
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Text(
                  widget.caption,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                  ),
                )
              ],
            ),
          ]
      ),
    );
  }
}