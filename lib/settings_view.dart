// Copyright (C) 2023 twyleg
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:playground_flutter_rating_app/main.dart';
import 'package:playground_flutter_rating_app/ratings_view.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';


class SettingsView extends StatefulWidget {
  const SettingsView({
    super.key,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {


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
                  value: 1000,
                  onChanged: (value) => print(value),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
