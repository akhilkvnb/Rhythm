import 'package:flutter/material.dart';
import 'package:music_player/functions/db_functions.dart';
import 'package:music_player/model/model.dart';

class AddButton extends StatefulWidget {
  AddButton({Key? key, required this.index, required this.cardindex, this.id})
      : super(key: key);
  dynamic index;
  dynamic cardindex;
  dynamic id;
  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> updatelist = [];
    List<dynamic> selectedlist = [];
    List<dynamic> deletelist = [];
    final playlistindex = DBfunction
        .SongListNotifier.value[widget.cardindex].songlst
        .contains(widget.id);
    final checkindex = DBfunction
        .SongListNotifier.value[widget.cardindex].songlst
        .indexWhere((element) => element == widget.id);

    if (playlistindex != true) {
      return IconButton(
          onPressed: () async {
            DBfunction.getplaylist();
            selectedlist.add(widget.id);
            updatelist = [
              selectedlist,
              DBfunction.SongListNotifier.value[widget.cardindex].songlst
            ].expand((element) => element).toList();
            final details = SongList(
                songlst: updatelist,
                name: DBfunction.SongListNotifier.value[widget.cardindex].name);
            await DBfunction.updatelist(widget.cardindex, details);
            setState(() {});
          },
          icon: const Icon(
            Icons.donut_large_outlined,
            color: Colors.white24,
          ));
    }
    return IconButton(
        onPressed: () async {
          setState(() {});
          DBfunction.SongListNotifier.value[widget.cardindex].songlst
              .removeAt(checkindex);
          updatelist = [
            deletelist,
            DBfunction.SongListNotifier.value[widget.cardindex].songlst
          ].expand((element) => element).toList();
          final details = SongList(
              songlst: updatelist,
              name: DBfunction.SongListNotifier.value[widget.cardindex].name);
          await DBfunction.updatelist(widget.cardindex, details);
        },
        icon: const Icon(
          Icons.donut_large_outlined,
          color: Color.fromARGB(255, 20, 139, 230),
        ));
  }
}
