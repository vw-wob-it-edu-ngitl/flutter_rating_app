// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'results_view.dart';
import 'ratings_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RatingAppModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Rate your experience!'),
      ),
    );
  }
}

class RatingAppModel extends ChangeNotifier {

  void addRating(Rating rating) {
    _ratings.update(
      rating,
      (value) => ++value,
      ifAbsent: () => 1,
    );
    notifyListeners();
  }

  int getRating(Rating rating) {
    return _ratings[rating] ?? 0;
  }

  void clearRatings() {
    for (final rating in Rating.values) {
      _ratings[rating] = 0;
    }
    notifyListeners();
  }

  Map<Rating, int> _ratings = {};
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;


  void onRating(Rating rating) {
    var ratingAppModel = context.read<RatingAppModel>();
    ratingAppModel.addRating(rating);
    print(ratingAppModel.getRating(rating));
    print(rating);
  }

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = RatingView(onRating: onRating,);
        break;
      case 1:
        page = ResultsView();
        break;
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: buildDrawer(context),
      body: page,
    );
  }


  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text(
              'Drawer Header',
            ),
          ),
          ListTile(
            title: const Text('Rating'),
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Results'),
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

