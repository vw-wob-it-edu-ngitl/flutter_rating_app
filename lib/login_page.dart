// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:playground_flutter_rating_app/app_bar.dart';
import 'package:playground_flutter_rating_app/drawer.dart';
import 'package:provider/provider.dart';
import 'rating_app_model.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    var ratingAppModel = context.read<RatingAppModel>();
                    ratingAppModel.login();
                    context.go('/ratings');
                  },
                  child: Text('Login')
              ),
            ],
          )
      ),
    );
  }
}
