// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:logging/logging.dart';
import 'package:flutter_rating_app/app_bar.dart';
import 'package:flutter_rating_app/drawer.dart';
import 'package:flutter_rating_app/rating_app_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final log = Logger('SETTINGS');

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
      appBar: buildMenuAppBar(context, AppLocalizations.of(context)!.settingsScreenAppBarTitle),
      drawer: buildDrawer(context),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.settingsScreenAppBarTitle),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: Text(AppLocalizations.of(context)!.settingsScreenSettingLanguage),
                trailing: Text(Provider.of<RatingAppModel>(context).getLocale()),
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeLanguagePage()),
                  );
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.timer),
                title: Text(AppLocalizations.of(context)!.settingsScreenSettingRatingTimeout),
                trailing: SizedBox(
                  width: 300,
                  height: 50,
                  child: SpinBox(
                    min: 0,
                    max: 10000,
                    step: 1000,
                    value: context
                        .read<RatingAppModel>()
                        .getRatingTimeout()
                        .toDouble(),
                    onChanged: (value) async {
                      context
                          .read<RatingAppModel>()
                          .setRatingTimeout(value.toInt());
                    },
                  ),
                ),
              ),
              SettingsTile(
                leading: const Icon(Icons.security),
                title: const Text("Pin"),
                trailing: Consumer<RatingAppModel>(
                  builder: (context, ratingAppModel, child) {
                    return Text(
                        ratingAppModel.getPin().toString().padLeft(4, '0'));
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

  Widget buildPinField(String title, Function(int) callback) {
    return TextField(
      decoration: InputDecoration(labelText: title),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      onChanged: (value) => callback(value != '' ? int.parse(value) : -1),
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
    return Scaffold(
      appBar: buildBackAppBar(context, AppLocalizations.of(context)!.changePin),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 200,
                  child:
                  buildPinField(AppLocalizations.of(context)!.oldPin, (value) => _providedOldPin = value)),
              SizedBox(
                  width: 200,
                  child:
                  buildPinField(AppLocalizations.of(context)!.newPin, (value) => _providedNewPin = value)),
              SizedBox(
                  width: 200,
                  child: buildPinField(AppLocalizations.of(context)!.newPinAgain,
                          (value) => _providedNewPinRepetition = value)),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    var ratingAppModel = context.read<RatingAppModel>();
                    var correctOldPin = ratingAppModel.getPin();

                    if (_providedOldPin != correctOldPin) {
                      showErrorDialog(context, AppLocalizations.of(context)!.incorrectOldPin);
                      log.info('Failed to set new PIN: Old PIN incorrect!');
                    } else if (_providedNewPin != _providedNewPinRepetition) {
                      showErrorDialog(context, AppLocalizations.of(context)!.newPinsUnequal);
                      log.info(
                          'Failed to set new PIN: Repetition unequal original PIN!');
                    } else {
                      ratingAppModel.setPin(_providedNewPin);
                      log.info('Setting new PIN!');
                      Navigator.pop(context);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.newPinsUnequal)
              ),
            ],
          )
      ),
    );
  }
}

class ChangeLanguagePage extends StatelessWidget {
  ChangeLanguagePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBackAppBar(context, AppLocalizations.of(context)!.changeLanguage),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                title: const Text('Deutsch'),
                leading: Radio<String>(
                  value: 'de',
                  groupValue: Provider.of<RatingAppModel>(context).getLocale(),
                  onChanged: (String? value) {
                    Provider.of<RatingAppModel>(context, listen: false).setLocale(value ?? 'en');
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('English'),
                leading: Radio<String>(
                  value: 'en',
                  groupValue: Provider.of<RatingAppModel>(context).getLocale(),
                  onChanged: (String? value) {
                    Provider.of<RatingAppModel>(context, listen: false).setLocale(value ?? 'en');
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}
