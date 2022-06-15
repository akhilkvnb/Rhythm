import 'package:flutter/material.dart';
import 'package:music_player/Screens/screensplash.dart';
import 'package:music_player/functions/db_functions.dart';
import 'package:settings_ui/settings_ui.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
      ),
      body: SettingsList(sections: [
        SettingsSection(tiles: [
          SettingsTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    backgroundColor: Colors.black,
                    title: Text(
                      'Rhythm developed By Akhil \n-Thank you for using',
                      style: TextStyle(
                          fontFamily: 'Cursive',
                          fontSize: 40,
                          color: Colors.white),
                    ),
                  ),
                );
              },
              child: const Text(
                'About',
              ),
            ),
          ),
          SettingsTile(
            leading: const Icon(Icons.memory_rounded),
            title: const Text('Version'),
            trailing: const Text('1.0.0'),
          ),
          SettingsTile(
              leading: const Icon(Icons.restart_alt_rounded),
              title: InkWell(
                  onTap: () {
                    DBfunction.restart();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (ctx) => const ScreenSplash()),
                        (route) => false);
                  },
                  child: const Text('Restart'))),
        ])
      ]),
    );
  }
}
