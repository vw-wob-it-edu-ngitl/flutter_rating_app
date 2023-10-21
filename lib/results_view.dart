// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:playground_flutter_rating_app/main.dart';
import 'package:playground_flutter_rating_app/ratings_view.dart';
import 'package:provider/provider.dart';

enum ResultsViewState {public, internal}

class ResultsView extends StatefulWidget {
  const ResultsView({
    super.key,
  });


  @override
  State<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {

  ResultsViewState resultsViewState = ResultsViewState.public;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: resultsViewState == ResultsViewState.public ? buildLoginPage() : buildResultsPage(),
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
                resultsViewState = ResultsViewState.internal;
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
