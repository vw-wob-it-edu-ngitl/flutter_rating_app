// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_rating_app/rating_app_model.dart';
import 'package:flutter_rating_app/app_bar.dart';
import 'package:flutter_rating_app/drawer.dart';
import 'package:flutter_rating_app/rating.dart';


class _RatingsMetaData extends StatelessWidget {
  const _RatingsMetaData();

  @override
  Widget build(BuildContext context) {
    var ratingAppModel = Provider.of<RatingAppModel>(context);

    var ratingMetaDataKeys = [
      "Total number",
      "Oldest rating",
      "Latest rating"
    ];
    var ratingMetaDataValues = [
      ratingAppModel.getTotalNumberOfRatings(),
      ratingAppModel.getOldestRatingDateTime() ?? "-",
      ratingAppModel.getLatestRatingDateTime() ?? "-"
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: () {
              var widgets = <Widget>[];
              for (var element in ratingMetaDataKeys) {
                widgets.add(Text(
                  "${element}:",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ));
              }
              return widgets;
            }(),
          ),
        ),
        SizedBox(width: 5,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: () {
              var widgets = <Widget>[];
              for (var element in ratingMetaDataValues) {
                widgets.add(Text(
                  "${element}",
                  textAlign: TextAlign.left,
                ));
              }
              return widgets;
            }(),
          ),
        )
      ],
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: createBarGroups(context),
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.center,
        groupsSpace: 180
      ),
      swapAnimationDuration: const Duration(milliseconds: 1000),
      swapAnimationCurve: Curves.linear,
    );
  }

  BarTouchData get barTouchData =>
      BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 40,
      child: AspectRatio(
        aspectRatio: 1,
        child: SvgPicture.asset(
            getAssetNameByRating(RatingValue.values[value.toInt()]),
            fit: BoxFit.contain
        ),
      )
    );
  }

  FlTitlesData get titlesData =>
      FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 200,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData =>
      FlBorderData(
        show: false,
      );

  BarChartGroupData createBarGroup(int x, int y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          width: 22,
          toY: y.toDouble(),
          color: getRatingColor(RatingValue.values[x])
        )
      ],
      showingTooltipIndicators: [0],
    );
  }

  List<BarChartGroupData> createBarGroups(BuildContext context) {
    var ratingAppModel = context.read<RatingAppModel>();
    List<BarChartGroupData> barChartGroupData = [];
    for (var value in RatingValue.values) {
      barChartGroupData.add(createBarGroup(value.index, ratingAppModel.getRating(value)));
    }
    return barChartGroupData;
  }
}

class ResultsPage extends StatelessWidget {
  const ResultsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMenuAppBar(context, 'Results'),
      drawer: buildDrawer(context),
      body: Center(
          child: Consumer<RatingAppModel>(
              builder: (context, ratingAppModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 500,
                      height: 500,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: _BarChart()
                      ),
                    ),
                    const SizedBox(height: 30,),
                    const _RatingsMetaData(),
                    const SizedBox(height: 30,),
                    ElevatedButton(
                        onPressed: () {
                          context.read<RatingAppModel>().clearRatings();
                        },
                        child: const Text('Clear!')
                    )
                  ],
                );
              }
          ),
      )
    );
  }
}
