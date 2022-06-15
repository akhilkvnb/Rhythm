import 'package:flutter/material.dart';
import 'package:music_player/Screens/pages/screenplay.dart';
import 'package:music_player/Screens/playlistcreate.dart';
import 'package:music_player/functions/db_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenFavourite extends StatelessWidget {
  const ScreenFavourite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DBfunction.getAllSongs();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 63, 15, 32),
              Color.fromARGB(255, 4, 5, 24)
            ],
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text('Favourite'),
            ),
            ValueListenableBuilder(
              valueListenable: DBfunction.favouriteNotifier,
              builder:
                  (BuildContext ctx, List<SongModel> favlist, Widget? child) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: favlist.length,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 5,
                            height: MediaQuery.of(context).size.height * .10,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromARGB(255, 90, 17, 42),
                                  Color.fromARGB(255, 8, 10, 49)
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: ListTile(
                                onTap: () {
                                  ScreenPlay.player.setAudioSource(
                                      Playlistsong.createPlaylist(favlist),
                                      initialIndex: index);
                                  ScreenPlay.player.play();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => ScreenPlay(
                                        songs: favlist,
                                      ),
                                    ),
                                  );
                                },
                                leading: QueryArtworkWidget(
                                  id: favlist[index].id,
                                  type: ArtworkType.AUDIO,
                                ),
                                title: Text(
                                  favlist[index].title,
                                  style: const TextStyle(color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  favlist[index].displayName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white24),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      DBfunction.delete(index);
                                    },
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Color.fromARGB(255, 240, 29, 92),
                                    )),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
