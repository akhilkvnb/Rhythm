import 'package:flutter/material.dart';
import 'package:music_player/Screens/pages/screensonglist.dart';
import 'package:music_player/functions/db_functions.dart';
import 'package:music_player/model/model.dart';

class ScreenPlaylist extends StatelessWidget {
  ScreenPlaylist({
    Key? key,
  }) : super(key: key);

  final foldercontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DBfunction.getplaylist();
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
            centerTitle: true,
            title: const Text('My Playlist'),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .12,
            width: MediaQuery.of(context).size.width * .5,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color.fromARGB(255, 77, 29, 53),
                        title: const Text(
                          'Create Folder',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: TextField(
                          controller: foldercontroller,
                          decoration: const InputDecoration(
                              hintText: 'Enter Name...',
                              hintStyle: TextStyle(color: Colors.white60)),
                          style: const TextStyle(color: Colors.white),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                if (foldercontroller.text.isNotEmpty) {
                                  final foldername = foldercontroller.text;
                                  final values =
                                      SongList(name: foldername, songlst: []);
                                  DBfunction.addplaylist(model: values);
                                  // DBfunction.addfolder(foldername);

                                  Navigator.of(context).pop();
                                  foldercontroller.clear();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.grey,
                                    content: Text('Please enter name'),
                                    margin: EdgeInsets.all(10),
                                    behavior: SnackBarBehavior.floating,
                                  ));
                                }
                              },
                              child: const Text(
                                'Create',
                                style: TextStyle(color: Colors.white70),
                              ))
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white70,
                  ),
                )),
                const Text(
                  'Create New Playlist',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .031,
          ),
          ValueListenableBuilder(
            valueListenable: DBfunction.SongListNotifier,
            builder:
                (BuildContext ctx, List<SongList> folderlist, Widget? child) {
              return Expanded(
                child: ListView.builder(
                    itemCount: folderlist.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 5,
                          height: MediaQuery.of(context).size.height * .11,
                          decoration: const BoxDecoration(
                              // color: Color.fromARGB(255, 138, 11, 70),
                              ),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (ctx) => ScreenList(
                                          cardindex: index,
                                        )),
                              );
                            },
                            contentPadding: const EdgeInsets.all(10),
                            leading: Image.asset('assets/img1.jpg'),
                            title: Text(
                              folderlist[index].name,
                              // DBfunction.SongListNotifier.value[index],
                              style: const TextStyle(color: Colors.white70),
                              overflow: TextOverflow.ellipsis,
                            ),
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor:
                                      const Color.fromARGB(255, 80, 79, 79),
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              DBfunction.deletePlaylist(index);
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
                          ),
                        ),
                      );
                    }),
              );
            },
          ),
        ],
      ),
    ));
  }
}
