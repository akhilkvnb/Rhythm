import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/Screens/fvbutton.dart';
import 'package:music_player/Screens/screensplash.dart';
import 'package:music_player/functions/db_functions.dart';
import 'package:music_player/model/model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  if (!Hive.isAdapterRegistered(SongListAdapter().typeId)) {
    Hive.registerAdapter(SongListAdapter());
  }
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  DBfunction.getAllSongs();
  ScreenfvButton();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ScreenSplash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
