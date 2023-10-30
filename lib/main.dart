// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:playground_flutter_rating_app/settings_page.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'results_page.dart';
import 'ratings_page.dart';
import 'rating_app_model.dart';
import 'package:go_router/go_router.dart';


void main() {
  runApp(const MyApp());
}

void onRating(BuildContext context, Rating rating) {
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
      builder: (context, state) => RatingsPage(onRating: onRating),
    ),
    GoRoute(
      name: 'results',
      path: '/results',
      builder: (context, state) => ResultsPage(),
    ),
    GoRoute(
      name: 'settings',
      path: '/settings',
      builder: (context, state) => SettingsPage(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    var ratingAppModel = RatingAppModel();

    return ChangeNotifierProvider(
      create: (context) => ratingAppModel,
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
