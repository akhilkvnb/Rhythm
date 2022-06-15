import 'package:flutter/material.dart';
import 'package:music_player/Screens/miniplayer.dart';
import 'package:music_player/Screens/pages/screenfavourite.dart';
import 'package:music_player/Screens/pages/screenhome.dart';
import 'package:music_player/Screens/pages/screenplay.dart';
import 'package:music_player/Screens/pages/screenplaylist.dart';
import 'package:music_player/functions/db_functions.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({
    Key? key,
  }) : super(key: key);

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  int _currentIndex = 0;
  @override
  void initState() {
    DBfunction.function();
    super.initState();
    ScreenPlay.player.currentIndexStream.listen((event) {
      if (event != null) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScreenPlay.player.currentIndex != null || ScreenPlay.player.playing
              ? Miniplayer()
              : const Text(''),
          BottomNavigationBar(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: const Color.fromARGB(255, 32, 32, 32),
              onTap: onTappedBar,
              currentIndex: _currentIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.music_note),
                  label: 'Music',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favourite',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_play),
                  label: 'Playlist',
                ),
              ]),
        ],
      ),
    );
  }

  final List<Widget> _children = [
    const ScreenHome(),
    const ScreenFavourite(),
    ScreenPlaylist(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
