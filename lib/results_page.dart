// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:playground_flutter_rating_app/ratings_page.dart';
import 'package:provider/provider.dart';
import 'rating_app_model.dart';

enum ResultsPageState {public, internal}

class ResultsPage extends StatefulWidget {
  const ResultsPage({
    super.key,
  });


  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {

  ResultsPageState resultsViewState = ResultsPageState.public;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: resultsViewState == ResultsPageState.public ? buildLoginPage() : buildResultsPage(),
    );
  }

  Widget buildLoginPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            decoration: const InputDecoration(labelText: "PIN:"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
            onPressed: () {
              setState(() {
                resultsViewState = ResultsPageState.internal;
              });
            },
            child: Text('Login')
        ),
      ],
    );
  }

  Widget buildResultsPage() {
    var ratingAppModel = context.read<RatingAppModel>();
    List<Widget> children = [];
    for (int i=0; i<Rating.values.length; i++) {
      children.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
              EmojiButton.getAssetNameByRating(Rating.values[i]),
              semanticsLabel: 'A red up arrow',
              fit: BoxFit.contain
          ),
          const SizedBox(height: 10,),
          Consumer<RatingAppModel>(
            builder: (context, ratingAppModel, child) {
              return Text("${ratingAppModel.getRating(Rating.values[i])}");
            },
          )
        ],
      ));
      if (i != Rating.values.length-1) {
        children.add(const SizedBox(
          width: 10,
        ));
      }
    }

    return Column(
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
    );
  }
}
