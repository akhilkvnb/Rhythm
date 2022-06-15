import 'package:flutter/material.dart';
import 'package:music_player/functions/db_functions.dart';

class ScreenfvButton extends StatefulWidget {
  ScreenfvButton({Key? key, this.id}) : super(key: key);
  dynamic id;
  @override
  State<ScreenfvButton> createState() => _ScreenfvButtonState();
}

class _ScreenfvButtonState extends State<ScreenfvButton> {
  @override
  Widget build(BuildContext context) {
    final dbindex = DBfunction.songid.contains(widget.id);
    final findex =
        DBfunction.songid.indexWhere((element) => element == widget.id);
    if (dbindex == true) {
      return IconButton(
          onPressed: () async {
            DBfunction.delete(findex);
            setState(() {});
          },
          icon: const Icon(
            Icons.favorite,
            color: Color.fromARGB(255, 240, 29, 92),
          ));
    }
    return IconButton(
      onPressed: () async {
        await DBfunction.addFavourite(widget.id);
        setState(() {});
      },
      icon: const Icon(
        Icons.favorite_border,
        color: Color.fromARGB(255, 153, 142, 145),
      ),
    );
  }
}
