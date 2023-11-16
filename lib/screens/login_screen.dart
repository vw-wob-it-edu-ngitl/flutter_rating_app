// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_app/app_bar.dart';
import 'package:flutter_rating_app/drawer.dart';
import 'package:flutter_rating_app/rating_app_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
  });

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Icon(
          Icons.error,
          size: 48,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.tryAgain),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var pin = -1;

    return Scaffold(
      appBar: buildMenuAppBar(context, 'Login'),
      drawer: buildDrawer(context),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  decoration: const InputDecoration(labelText: "PIN:"),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  obscuringCharacter: '*',
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  onChanged: (value) => pin = (value != '' ? int.parse(value) : -1),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    var ratingAppModel = context.read<RatingAppModel>();

                    if (pin == ratingAppModel.getPin()) {
                      ratingAppModel.login();
                      context.go('/ratings');
                    } else {
                      showErrorDialog(context, AppLocalizations.of(context)!.incorrectPin);
                    }
                  },
                  child: const Text('Login')
              ),
            ],
          )
      ),
    );
  }
}
