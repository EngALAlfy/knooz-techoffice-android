import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:techoffice/utils/Pref.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notify = true;

  @override
  void initState() {
    super.initState();
    getBool("notify").then((value) => setState(() {
          notify = value ?? true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الاعدادات"),
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('الاشعارت'),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: (value) async {
                  await setBool("notify", value);

                  getBool("notify").then((value) => setState(() {
                        notify = value ?? true;
                      }));
                },
                initialValue: notify,
                leading: Icon(Icons.notifications_active_outlined),
                title: Text('تفعيل الاشعارات'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
