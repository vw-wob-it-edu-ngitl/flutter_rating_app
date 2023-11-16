// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';


class CustomAppBar extends AppBar {
  CustomAppBar(
      BuildContext context,
      String title,
      {super.leading, super.key}) : super(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.white),
    title: Text(title),
  ) {}
}

AppBar buildMenuAppBar(BuildContext context, String title) {
  return CustomAppBar(context, title, leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        );
      }
    ),
  );
}

AppBar buildBackAppBar(BuildContext context, String title) {
  return CustomAppBar(
    context, title
  );
}