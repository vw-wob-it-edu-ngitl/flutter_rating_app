// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:playground_flutter_rating_app/settings_view.dart';
import 'results_view.dart';
import 'ratings_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RatingAppModel(),
      child: MaterialApp(
        title: 'Rating App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
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
      case 2:
        page = SettingsView();
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: const TextStyle(color: Colors.white),),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          }
        ),
      ),
      drawer: buildDrawer(context),
      body: page,
    );
  }


  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const SizedBox(
              // size: Size.infinite,
              width: double.infinity,
              height: double.infinity,
              child: Text("Menu", style: TextStyle(color: Colors.white))
            )
          ),
          Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('Rating'),
                    leading: const Icon(Icons.emoji_emotions),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Results'),
                    leading: const Icon(Icons.numbers),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
              Navigator.pop(context);
            },
          ),

        ],
      ),
    );
  }
}

