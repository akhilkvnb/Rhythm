import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_player/Screens/fvbutton.dart';
import 'package:music_player/Screens/pages/screenplay.dart';
import 'package:music_player/Screens/pages/screensearch.dart';
import 'package:music_player/Screens/pages/screensettings.dart';
import 'package:music_player/Screens/playlistcreate.dart';
import 'package:music_player/functions/db_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);
// variables
  static List<SongModel> songs = [];
  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  //dedfine on audio plugin
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool isPlayerViewVisible = false;
  @override
  void initState() {
    super.initState();
    setState(() {});
    requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    DBfunction.function();
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
              title: const Text('Music'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ScreenSearch(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const ScreenSettings(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                )
              ],
            ),
            FutureBuilder<List<SongModel>>(
              //defualt items
              future: _audioQuery.querySongs(
                sortType: SongSortType.DATE_ADDED,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, item) {
                //loading context indicator
                if (item.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                //no song found
                if (item.data!.isEmpty) {
                  return const Center(
                    child: Text('No song found'),
                  );
                }

                ScreenHome.songs.clear();
                ScreenHome.songs = item.data!;

                return Expanded(
                  child: GridView.builder(
                      itemCount: item.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisSpacing: 20,
                        // mainAxisExtent: 200,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 20,
                            ),
                            child: InkWell(
                              onTap: () async {
                                ScreenPlay.player.setAudioSource(
                                    Playlistsong.createPlaylist(
                                        ScreenHome.songs),
                                    initialIndex: index);
                                ScreenPlay.player.play();
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => ScreenPlay(
                                      songs: ScreenHome.songs,
                                    ),
                                  ),
                                );
                              },
                              child: ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .24,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color.fromARGB(255, 90, 17, 42),
                                              Color.fromARGB(255, 8, 10, 49)
                                            ]),
                                      ),
                                      child: ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5, top: 5),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .15,
                                                  width: double.infinity,
                                                  color: Colors.black,
                                                  child: QueryArtworkWidget(
                                                    id: item.data![index].id,
                                                    type: ArtworkType.AUDIO,
                                                    artworkBorder:
                                                        BorderRadius.circular(
                                                            0),
                                                    artworkFit: BoxFit.cover,
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          item.data![index]
                                                              .title,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white60),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      ScreenfvButton(
                                                        id: ScreenHome
                                                            .songs[index].id,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ));
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }

      setState(() {});
    }
  }
}
