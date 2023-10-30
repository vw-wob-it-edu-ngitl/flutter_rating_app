// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playground_flutter_rating_app/rating_app_model.dart';
import 'package:provider/provider.dart';


Drawer buildDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary,
            ),
            child: const SizedBox(
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
                    context.go('/ratings');
                  },
                ),
                Consumer<RatingAppModel>(
                  builder: (context, ratingAppModel, child) {
                    if (ratingAppModel.isLoggedIn()) {
                      return ListTile(
                        title: const Text('Results'),
                        leading: const Icon(Icons.numbers),
                        onTap: () {
                          context.go('/results');
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  }
                )
              ],
            )
        ),
        const Spacer(),
        const Divider(),

        Consumer<RatingAppModel>(
            builder: (context, ratingAppModel, child) {
              if (ratingAppModel.isLoggedIn()) {
                return ListTile(
                  title: const Text('Settings'),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    context.go('/settings');
                  },
                );
              } else {
                return const SizedBox();
              }
            }
        ),

        Consumer<RatingAppModel>(
          builder: (context, ratingAppModel, child) {
            if (ratingAppModel.isLoggedIn()) {
              return ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
                onTap: () {
                  ratingAppModel.logout();
                  context.go('/ratings');
                },
              );
            } else {
              return ListTile(
                title: const Text('Login'),
                leading: const Icon(Icons.login),
                onTap: () {
                  context.go('/login');
                },
              );
            }
          },
        ),
      ],
    ),
  );
}