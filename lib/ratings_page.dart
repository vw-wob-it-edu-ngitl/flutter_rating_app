// Copyright (C) 2023 twyleg
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'rating_app_model.dart';
import 'drawer.dart';
import 'app_bar.dart';


enum RatingValue {veryLow, low, medium, high, veryHigh}


class RatingsPage extends StatelessWidget {
  const RatingsPage({
    super.key,
    required this.onRating
  });

  final void Function(BuildContext, RatingValue) onRating;

  void setEnabled(BuildContext context, bool enabled) {
    var ratingsViewModel = context.read<RatingsViewModel>();
    ratingsViewModel.enabled = enabled;
    ratingsViewModel.notifyListeners();
  }


  void buttonCallback(BuildContext context, RatingValue rating) {
    onRating(context, rating);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const AlertDialog(
        title: Icon(
          Icons.favorite,
          color: Colors.pink,
          size: 48,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Awesome!\nThank You!!!',
              style: TextStyle(fontSize: 32.0,fontWeight: FontWeight.bold, ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(),
          ],
        ),
      ),
    );

    var timeout = context.read<RatingAppModel>().getRatingTimeout();

    Timer scheduleTimeout() =>
        Timer(Duration(milliseconds: timeout), () {
          setEnabled(context, true);
          Navigator.popUntil(context, ModalRoute.withName('ratings'));
        });

    setEnabled(context, false);
    scheduleTimeout();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMenuAppBar(context, 'Rate us!'),
      drawer: buildDrawer(context),
      body: ChangeNotifierProvider(
        create: (context) => RatingsViewModel(),
        child: Center(
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
        ),
      ),
    );
  }
}

class RatingsViewModel extends ChangeNotifier {
  bool enabled = true;
}


class EmojiButton extends StatefulWidget {
  EmojiButton({
    super.key,
    required this.rating,
    required this.onClicked
  });

  EmojiButton.veryLow({super.key, required this.onClicked}) :
        rating = RatingValue.veryLow;

  EmojiButton.low({super.key, required this.onClicked}) :
        rating = RatingValue.low;

  EmojiButton.medium({super.key, required this.onClicked}) :
        rating = RatingValue.medium;

  EmojiButton.high({super.key, required this.onClicked}) :
        rating = RatingValue.high;

  EmojiButton.veryHigh({super.key, required this.onClicked}) :
        rating = RatingValue.veryHigh;

  final RatingValue rating;

  final void Function(BuildContext, RatingValue) onClicked;

  @override
  State<EmojiButton> createState() => _EmojiButtonState();

  static String getAssetNameByRating(rating) {
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