import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/Screens/addbutton.dart';
import 'package:music_player/Screens/fvbutton.dart';
import 'package:music_player/Screens/pages/screenhome.dart';
import 'package:music_player/Screens/pages/screenplaylist.dart';
import 'package:music_player/functions/db_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

// ignore: must_be_immutable
class ScreenPlay extends StatefulWidget {
  //player
  static final AudioPlayer player = AudioPlayer();
  // variables
  static String currentSongTitle = '';
  static dynamic currentIndex = 0;
  ScreenPlay({
    Key? key,
    this.songs,
  }) : super(key: key);
  List<SongModel>? songs;
  static List<SongModel> minilist = [];
  @override
  State<ScreenPlay> createState() => _ScreenPlayState();
}

class _ScreenPlayState extends State<ScreenPlay> {
  @override
  void initState() {
    ScreenPlay.minilist.clear();
    for (var i = 0; i < widget.songs!.length; i++) {
      ScreenPlay.minilist.add(widget.songs![i]);
    }
    super.initState();

    ScreenPlay.player.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentPlayingSongDetails(index);
      }
    });
  }

//Duration state stream
  Stream<DurationState> get durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          ScreenPlay.player.positionStream,
          ScreenPlay.player.durationStream,
          (position, duration) => DurationState(
                position: position,
                total: duration ?? Duration.zero,
              ));
  @override
  Widget build(BuildContext context) {
    DBfunction.getplaylist();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromARGB(255, 92, 22, 47),
                  Color.fromARGB(255, 4, 5, 24)
                ],
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Container(
                                decoration: const BoxDecoration(
                                  // color: Colors.white,
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color.fromARGB(255, 92, 22, 47),
                                      Color.fromARGB(255, 2, 5, 66)
                                      //  Color.fromARGB(255, 92, 22, 47),
                                      //  Color.fromARGB(255, 2, 5, 66)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50)),
                                ),
                                child: ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 100,
                                          right: 100,
                                          top: 20,
                                          bottom: 8),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .1,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            ScreenPlaylist()));
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            const Text(
                                              'create playlist',
                                              style: TextStyle(
                                                  color: Colors.white70),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .43,
                                      child: ValueListenableBuilder(
                                        valueListenable:
                                            DBfunction.SongListNotifier,
                                        builder: (BuildContext context,
                                            List<dynamic> nowplaylist,
                                            Widget? child) {
                                          return ListView.builder(
                                            itemCount: DBfunction
                                                .SongListNotifier.value.length,
                                            itemBuilder: ((context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 20,
                                                  left: 5,
                                                  right: 5,
                                                ),
                                                child: ListTile(
                                                  minVerticalPadding: 25,
                                                  leading: Image.asset(
                                                      'assets/img1.jpg'),
                                                  title: Text(
                                                    DBfunction.SongListNotifier
                                                        .value[index].name
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white70),
                                                  ),
                                                  trailing: AddButton(
                                                    index:
                                                        ScreenPlay.currentIndex,
                                                    cardindex: index,
                                                    id: widget
                                                        .songs![ScreenPlay
                                                            .currentIndex]
                                                        .id,
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.playlist_add,
                        color: Colors.white70,
                        size: 28,
                      ))
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .35,
                    width: MediaQuery.of(context).size.width * .8,
                    color: Colors.black,
                    child: QueryArtworkWidget(
                      id: widget.songs![ScreenPlay.currentIndex].id,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(0),
                      artworkFit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Expanded(flex: 2, child: SizedBox()),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: SizedBox(
                    child: Marquee(
                      text: widget.songs![ScreenPlay.currentIndex].title,
                      style: const TextStyle(
                          color: Colors.white, overflow: TextOverflow.ellipsis),
                      blankSpace: 20.0,
                      velocity: 50.0, //speed
                      pauseAfterRound: const Duration(seconds: 1),
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              StreamBuilder<DurationState>(
                stream: durationStateStream,
                builder: (context, snapshot) {
                  final durationState = snapshot.data;
                  final progress = durationState?.position ?? Duration.zero;
                  final total = durationState?.total ?? Duration.zero;

                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 40, right: 40, bottom: 5, top: 10),
                    child: ProgressBar(
                      progress: progress,
                      total: total,
                      barHeight: 3,
                      progressBarColor: Colors.white60,
                      baseBarColor: Colors.white70,
                      thumbColor: Colors.white,
                      thumbRadius: 6,
                      timeLabelTextStyle: const TextStyle(color: Colors.white),
                      onSeek: (duration) {
                        ScreenPlay.player.seek(duration);
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                    width: MediaQuery.of(context).size.width * .8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            ScreenPlay.player.loopMode == LoopMode.one
                                ? ScreenPlay.player.setLoopMode(LoopMode.all)
                                : ScreenPlay.player.setLoopMode(LoopMode.one);
                            // toast(context, "repect crnt song");
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            child: StreamBuilder<LoopMode>(
                                stream: ScreenPlay.player.loopModeStream,
                                builder: (context, snapshot) {
                                  final loopMode = snapshot.data;
                                  if (LoopMode.one == loopMode) {
                                    return const Icon(
                                      Icons.repeat_one,
                                      color: Colors.black,
                                    );
                                  }
                                  return const Icon(
                                    Icons.repeat,
                                    color: Colors.white70,
                                  );
                                }),
                          ),
                        ),
                        ScreenfvButton(
                          id: widget.songs![ScreenPlay.currentIndex].id,
                        )
                      ],
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .1,
                width: MediaQuery.of(context).size.width * .8,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromARGB(255, 160, 4, 58),
                      Color.fromARGB(255, 24, 25, 99),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () async {
                          if (ScreenPlay.player.hasPrevious) {
                            await ScreenPlay.player.seekToPrevious();
                            // widget.index = ScreenPlay.player.currentIndex;
                            setState(() {});
                          } else {
                            // widget.index = 0;
                            ScreenPlay.currentIndex =
                                ScreenHome.songs.length - 1;
                            await ScreenPlay.player.play();
                            setState(() {});
                          }
                        },
                        child: const Icon(
                          Icons.skip_previous,
                          color: Colors.white70,
                          size: 40,
                        ),
                      ),
                    ),
                    Flexible(
                        child: InkWell(
                      onTap: () async {
                        if (ScreenPlay.player.playing) {
                          ScreenPlay.player.pause();
                        } else {
                          if (ScreenPlay.player.currentIndex != null) {
                            ScreenPlay.player.play();
                          }
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 4,
                        height: MediaQuery.of(context).size.height * 4,
                        decoration: getDecoration(
                          BoxShape.circle,
                          const Offset(2, 2),
                          2.0,
                          0.0,
                        ),
                        child: StreamBuilder<bool>(
                            stream: ScreenPlay.player.playingStream,
                            builder: ((context, snapshot) {
                              bool? playingState = snapshot.data;
                              if (playingState != null && playingState) {
                                return const Icon(
                                  Icons.pause,
                                  size: 40,
                                  color: Colors.white,
                                );
                              }
                              return const Icon(
                                Icons.play_arrow,
                                size: 40,
                                color: Colors.white,
                              );
                            })),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () async {
                          if (ScreenPlay.player.hasNext) {
                            await ScreenPlay.player.seekToNext();
                            setState(() {});
                          } else {
                            ScreenPlay.currentIndex = 0;
                            // widget.index = 0;
                            await ScreenPlay.player.play();
                            setState(() {});
                          }
                        },
                        child: const Icon(
                          Icons.skip_next,
                          color: Colors.white70,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(flex: 5, child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  void _updateCurrentPlayingSongDetails(int index) {
    setState(() {
      if (ScreenPlay.player.currentIndex != null) {
        ScreenPlay.currentIndex = ScreenPlay.player.currentIndex!;
      }
    });
  }

  BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromARGB(255, 177, 8, 67),
            Color.fromARGB(255, 31, 34, 145),
          ],
        ),
        shape: shape,
        boxShadow: [
          BoxShadow(
            offset: offset,
            color: const Color.fromARGB(255, 73, 3, 38),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
          BoxShadow(
            offset: offset,
            color: Colors.black,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          )
        ]);
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
