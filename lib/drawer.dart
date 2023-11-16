// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'rating_app_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
                  title: Text(AppLocalizations.of(context)!.drawerRatings),
                  leading: const Icon(Icons.emoji_emotions),
                  onTap: () {
                    context.go('/ratings');
                  },
                ),
                Consumer<RatingAppModel>(
                  builder: (context, ratingAppModel, child) {
                    if (ratingAppModel.isLoggedIn()) {
                      return ListTile(
                        title: Text(AppLocalizations.of(context)!.drawerResults),
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
                  title: Text(AppLocalizations.of(context)!.drawerSettings),
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