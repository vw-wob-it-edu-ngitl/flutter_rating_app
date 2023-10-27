// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
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
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text("General"),
          tiles: <SettingsTile>[
            SettingsTile(
              leading: Icon(Icons.timer),
              title: Text("Rating timeout (ms)"),
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
            )
          ],
        ),
      ],
    );
  }
}
