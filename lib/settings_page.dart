// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:playground_flutter_rating_app/app_bar.dart';
import 'package:playground_flutter_rating_app/drawer.dart';
import 'rating_app_model.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMenuAppBar(context, 'Settings'),
      drawer: buildDrawer(context),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text("General"),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.timer),
                title: const Text("Rating timeout (ms)"),
                trailing: SizedBox(
                  width: 300,
                  height: 50,
                  child: SpinBox(
                    min: 0,
                    max: 10000,
                    step: 1000,
                    value: context.read<RatingAppModel>().getRatingTimeout().toDouble(),
                    onChanged: (value) async {
                      context.read<RatingAppModel>().setRatingTimeout(value.toInt());
                    },
                  ),
                ),
              ),
              SettingsTile(
                title: Text("Pin"),
                trailing: Consumer<RatingAppModel>(
                  builder: (context, ratingAppModel, child) {
                    return Text(ratingAppModel.getPin().toString().padLeft(4, '0'));
                  },
                ),
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePinPage()),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}


class ChangePinPage extends StatelessWidget {
  ChangePinPage({
      super.key,
  });

  int _providedOldPin = 0;
  int _providedNewPin = 0;
  int _providedNewPinRepetition = 0;

  Widget buildPinField(String title, int pin) {
    return TextField(
      decoration: InputDecoration(labelText: title),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      onChanged: (value) {
        pin = int.parse(value);
      },
    );
  }

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
              style: const TextStyle(fontSize: 32.0,fontWeight: FontWeight.bold, ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBackAppBar(context, 'Change PIN'),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: buildPinField('Old PIN', _providedOldPin)
              ),
              SizedBox(
                width: 200,
                child: buildPinField('New PIN', _providedNewPin)
              ),
              SizedBox(
                width: 200,
                child: buildPinField('New PIN again', _providedNewPinRepetition)
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    var ratingAppModel = context.read<RatingAppModel>();
                    var correctOldPin = ratingAppModel.getPin();

                    if (_providedOldPin != correctOldPin) {
                      showErrorDialog(context, "Incorrect old PIN!");
                    } else if (_providedNewPin != _providedNewPinRepetition) {
                      showErrorDialog(context, "New PINs are not equal!!");
                    } else {
                      ratingAppModel.setPin(_providedNewPin);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Change pin!')
              ),
            ],
          )
      ),
    );
  }

}
