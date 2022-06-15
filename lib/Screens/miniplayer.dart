import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/Screens/pages/screenhome.dart';
import 'package:music_player/Screens/pages/screenplay.dart';
import 'package:music_player/Screens/playlistcreate.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Miniplayer extends StatefulWidget {
  Miniplayer({Key? key}) : super(key: key);
  List<SongModel> smlist = [];
  @override
  State<Miniplayer> createState() => _MiniplayerState();
}

class _MiniplayerState extends State<Miniplayer> {
  @override
  void initState() {
    super.initState();
    ScreenPlay.player.currentIndexStream.listen((event) {
      if (event != null) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.smlist.clear();
          for (var i = 0; i < ScreenPlay.minilist.length; i++) {
            widget.smlist.add(ScreenPlay.minilist[i]);
          }
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => ScreenPlay(
                    songs: widget.smlist,
                  )));
        },
        child: Container(
          height: MediaQuery.of(context).size.height * .1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 90, 17, 42),
                Color.fromARGB(255, 8, 10, 49)
              ],
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
            leading: QueryArtworkWidget(
              id: ScreenPlay.minilist[ScreenPlay.player.currentIndex!].id,
              type: ArtworkType.AUDIO,
              artworkBorder: BorderRadius.circular(0),
              artworkFit: BoxFit.fill,
            ),
            title: Marquee(
              text: ScreenPlay.minilist[ScreenPlay.player.currentIndex!].title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white60,
                overflow: TextOverflow.ellipsis,
              ),
              blankSpace: 20.0,
              velocity: 50.0, //speed
              pauseAfterRound: const Duration(seconds: 1),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await ScreenPlay.player.setAudioSource(
                        Playlistsong.createPlaylist(ScreenHome.songs),
                        initialIndex: ScreenPlay.currentIndex);
                    if (ScreenPlay.player.playing) {
                      ScreenPlay.player.pause();
                    } else {
                      if (ScreenPlay.player.currentIndex != null) {
                        ScreenPlay.player.play();
                      }
                    }
                  },
                  child: StreamBuilder<bool>(
                      stream: ScreenPlay.player.playingStream,
                      builder: ((context, snapshot) {
                        bool? playingState = snapshot.data;
                        if (playingState != null && playingState) {
                          return const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.pause,
                              size: 30,
                              color: Colors.white,
                            ),
                          );
                        }
                        return const Padding(
                          padding: EdgeInsets.only(
                            right: 20,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: Colors.white,
                          ),
                        );
                      })),
                ),
              ],
            ),
          ),
        ));
  }
}
