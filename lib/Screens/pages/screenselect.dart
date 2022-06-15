import 'package:flutter/material.dart';
import 'package:music_player/Screens/addbutton.dart';
import 'package:music_player/Screens/pages/screenhome.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenSelect extends StatefulWidget {
  ScreenSelect({
    Key? key,
    this.cardindex1,
  }) : super(key: key);
  int? cardindex1;

  static List<dynamic> updatelist = [];
  List<dynamic> selectedlist = [];

  @override
  State<ScreenSelect> createState() => _ScreenSelectState();
}

class _ScreenSelectState extends State<ScreenSelect> {
  @override
  Widget build(BuildContext context) {
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
              title: const Text('My Playlist'),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: ScreenHome.songs.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: ListTile(
                              leading: QueryArtworkWidget(
                                id: ScreenHome.songs[index].id,
                                type: ArtworkType.AUDIO,
                              ),
                              title: Text(
                                ScreenHome.songs[index].title,
                                style: const TextStyle(color: Colors.white70),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                ScreenHome.songs[index].displayName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white24),
                              ),
                              trailing: AddButton(
                                index: index,
                                cardindex: widget.cardindex1!,
                                id: ScreenHome.songs[index].id,
                              )),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
