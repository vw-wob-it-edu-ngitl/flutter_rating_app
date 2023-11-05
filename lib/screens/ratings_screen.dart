// Copyright (C) 2023 twyleg
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_app/rating_app_model.dart';
import 'package:flutter_rating_app/drawer.dart';
import 'package:flutter_rating_app/app_bar.dart';
import 'package:flutter_rating_app/emoji_button.dart';
import 'package:flutter_rating_app/rating.dart';

class RatingsViewModel extends ChangeNotifier {
  bool enabled = true;
}


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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "How was your experience?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40
                  ),
                ),
                Expanded(child: Container()),
                const SizedBox(
                  height: 200,
                  width: 200,
                  child: Placeholder(),
                )
              ],
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  EmojiButton.veryLow(caption: "Very bad!", onClicked: buttonCallback),
                  const SizedBox(width: 10),
                  EmojiButton.low(onClicked: buttonCallback),
                  const SizedBox(width: 10),
                  EmojiButton.medium(caption: "Medium!", onClicked: buttonCallback),
                  const SizedBox(width: 10),
                  EmojiButton.high(onClicked: buttonCallback),
                  const SizedBox(width: 10),
                  EmojiButton.veryHigh(caption: "Very good!", onClicked: buttonCallback),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}



