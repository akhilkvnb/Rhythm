import 'package:flutter/material.dart';
import 'package:music_player/Screens/pages/screenhome.dart';
import 'package:music_player/Screens/pages/screenplay.dart';
import 'package:music_player/Screens/playlistcreate.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenSearch extends StatelessWidget {
  ScreenSearch({Key? key}) : super(key: key);
  ValueNotifier<List<SongModel>> temp = ValueNotifier([]);
  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 63, 15, 32),
                Color.fromARGB(255, 4, 5, 24)
              ]),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 80,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextField(
                  onTap: () {},
                  onChanged: (String? value) {
                    if (value == null || value.isEmpty) {
                      temp.value.addAll(ScreenHome.songs);
                    } else {
                      temp.value.clear();
                      for (SongModel i in ScreenHome.songs) {
                        if (i.title
                            .toLowerCase()
                            .contains(value.toLowerCase())) {
                          temp.value.add(i);
                        }
                        temp.notifyListeners();
                      }
                    }
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 105, 101, 101),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    hintText: 'Songs...',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 105, 101, 101),
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .9,
                    child: ValueListenableBuilder(
                      valueListenable: temp,
                      builder: (BuildContext ctx, List<SongModel> searchData,
                          Widget? child) {
                        return ListView.builder(
                            itemBuilder: (ctx, index) {
                              final data = searchData[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, bottom: 8),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 5,
                                  height:
                                      MediaQuery.of(context).size.height * .10,
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
                                        id: data.id,
                                        type: ArtworkType.AUDIO,
                                      ),
                                      title: Text(
                                        data.title,
                                        style: const TextStyle(
                                            color: Colors.white70),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        ScreenPlay.player.setAudioSource(
                                          Playlistsong.createPlaylist(
                                              searchData),
                                          initialIndex: index,
                                        );
                                        ScreenPlay.player.play();
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (ctx) => ScreenPlay(
                                            songs: searchData,
                                          ),
                                        ));
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: searchData.length);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
