import 'package:flutter/material.dart';
import 'package:music_player/Screens/pages/screenhome.dart';
import 'package:music_player/Screens/pages/screenplay.dart';
import 'package:music_player/Screens/pages/screenselect.dart';
import 'package:music_player/Screens/playlistcreate.dart';
import 'package:music_player/functions/db_functions.dart';
import 'package:music_player/model/model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenList extends StatefulWidget {
  ScreenList({Key? key, this.cardindex}) : super(key: key);
  int? cardindex;

  @override
  State<ScreenList> createState() => _ScreenListState();
}

class _ScreenListState extends State<ScreenList> {
  @override
  Widget build(BuildContext context) {
    Songcheck.selectsong(widget.cardindex);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
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
              title: Text(
                  DBfunction.SongListNotifier.value[widget.cardindex!].name),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ScreenSelect(
                                cardindex1: widget.cardindex,
                              )));
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ))
              ],
            ),
            ValueListenableBuilder(
                valueListenable: DBfunction.SongListNotifier,
                builder:
                    (BuildContext ctx, List<dynamic> listsong, Widget? child) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: DBfunction.SongListNotifier
                            .value[widget.cardindex!].songlst.length,
                        itemBuilder: ((ctx, index) {
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
                                  leading: QueryArtworkWidget(
                                    id: ScreenHome
                                        .songs[Songcheck.Playsong.value[index]]
                                        .id,
                                    type: ArtworkType.AUDIO,
                                  ),
                                  title: Text(
                                    ScreenHome
                                        .songs[Songcheck.Playsong.value[index]]
                                        .title,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: const Color.fromARGB(
                                            255, 80, 79, 79),
                                        title: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              TextButton(
                                                  onPressed: () async {
                                                    DBfunction
                                                        .SongListNotifier
                                                        .value[
                                                            widget.cardindex!]
                                                        .songlst
                                                        .removeAt(index);
                                                    ScreenSelect.updatelist = [
                                                      DBfunction
                                                          .SongListNotifier
                                                          .value[
                                                              widget.cardindex!]
                                                          .songlst
                                                    ]
                                                        .expand((element) =>
                                                            element)
                                                        .toList();
                                                    final details = SongList(
                                                        songlst: ScreenSelect
                                                            .updatelist,
                                                        name: DBfunction
                                                            .SongListNotifier
                                                            .value[widget
                                                                .cardindex!]
                                                            .name);
                                                    await DBfunction.updatelist(
                                                        widget.cardindex,
                                                        details);
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  onTap: () async {
                                    ScreenPlay.player.setAudioSource(
                                        Playlistsong.createPlaylist(
                                            DBfunction.playmodel.value),
                                        initialIndex: index);
                                    ScreenPlay.player.play();
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => ScreenPlay(
                                          songs: DBfunction.playmodel.value,
                                        ),
                                      ),
                                    );
                                  },
                                  subtitle: Text(
                                    ScreenHome
                                        .songs[Songcheck.Playsong.value[index]]
                                        .displayName,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        const TextStyle(color: Colors.white24),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
