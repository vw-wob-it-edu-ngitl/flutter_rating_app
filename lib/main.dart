// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'login_page.dart';
import 'results_page.dart';
import 'ratings_page.dart';
import 'rating_app_model.dart';
import 'settings_page.dart';

final log = Logger('MAIN');


void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.time.toIso8601String()}-${record.level.name}: ${record.message}');
  });

  log.info('Rating App Started!');

  runApp(RatingApp());
}

void onRating(BuildContext context, RatingValue rating) {
  var ratingAppModel = context.read<RatingAppModel>();
  ratingAppModel.addRating(rating);
}

// GoRouter configuration
final _router = GoRouter(
  initialLocation: '/ratings',
  routes: [
    GoRoute(
      name: 'ratings', // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/ratings',
      builder: (context, state) => const RatingsPage(onRating: onRating),
    ),
    GoRoute(
      name: 'results',
      path: '/results',
      builder: (context, state) => const ResultsPage(),
    ),
    GoRoute(
      name: 'settings',
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);

class RatingApp extends StatefulWidget {
  RatingApp({super.key});

  @override
  State<RatingApp> createState() => _RatingAppState();
}

class _RatingAppState extends State<RatingApp> {
  RatingAppModel ratingAppModel = RatingAppModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ratingAppModel.init();

  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider.value(
      value: ratingAppModel,
      child: MaterialApp.router(
        title: 'Rating App',
        routerConfig: _router,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
      ),
    );
  }
}
