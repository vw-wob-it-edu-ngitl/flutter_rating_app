// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'rating_app_model.dart';
import 'app_bar.dart';
import 'drawer.dart';
import 'ratings_page.dart';


class ResultsPage extends StatelessWidget {
  const ResultsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    var ratingAppModel = context.read<RatingAppModel>();
    List<Widget> children = [];
    for (int i=0; i<RatingValue.values.length; i++) {
      children.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
              EmojiButton.getAssetNameByRating(RatingValue.values[i]),
              semanticsLabel: 'A red up arrow',
              fit: BoxFit.contain
          ),
          const SizedBox(height: 10,),
          Consumer<RatingAppModel>(
            builder: (context, ratingAppModel, child) {
              return Text("${ratingAppModel.getRating(RatingValue.values[i])}");
            },
          )
        ],
      ));
      if (i != RatingValue.values.length-1) {
        children.add(const SizedBox(
          width: 10,
        ));
      }
    }

    return Scaffold(
      appBar: buildMenuAppBar(context, 'Results'),
      drawer: buildDrawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
            SizedBox(height: 30,),
            ElevatedButton(
                onPressed: () {
                  ratingAppModel.clearRatings();
                },
                child: const Text('Clear!')
            )
          ],
        )
      ),
    );
  }
}
