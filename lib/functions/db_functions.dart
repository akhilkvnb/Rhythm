import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/Screens/pages/screenhome.dart';
import 'package:music_player/model/model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DBfunction {
  static ValueNotifier<List<SongModel>> favouriteNotifier = ValueNotifier([]);
  static dynamic songid;
  static ValueNotifier<List<dynamic>> fvmodel = ValueNotifier([]);

  static addFavourite(value) async {
    final favouriteDB = await Hive.openBox('favourite_db');
    await favouriteDB.add(value);
    //favouriteNotifier.value.addAll(favouriteDB.values);
    getAllSongs();
  }

  static getAllSongs() async {
    final favouriteDB = await Hive.openBox('favourite_db');
    favouriteNotifier.value.clear();
    songid = favouriteDB.values.toList();
    function();
  }

  static function() async {
    final favouriteDB = await Hive.openBox('favourite_db');
    final dynamic dbsongs = favouriteDB.values.toList();
    favouriteNotifier.value.clear();
    fvmodel.value.clear();
    for (int i = 0; i < dbsongs.length; i++) {
      for (int j = 0; j < ScreenHome.songs.length; j++) {
        if (ScreenHome.songs[j].id == dbsongs[i]) {
          favouriteNotifier.value.add(ScreenHome.songs[j]);
          fvmodel.value.add(j);
        }
      }
    }

    favouriteNotifier.notifyListeners();
    fvmodel.notifyListeners();
  }

  static delete(index) async {
    final favouriteDB = await Hive.openBox('favourite_db');
    await favouriteDB.deleteAt(index);
    favouriteNotifier.notifyListeners();
    getAllSongs();
  }
  //-------------restart-------------------//

  static restart() async {
    final favouriteDB = await Hive.openBox('favourite_db');
    final playlistDB = await Hive.openBox<SongList>('playlist_song');
    playlistDB.clear();
    favouriteDB.clear();
  }
//----------------playlist----------------//

  static ValueNotifier<List<SongList>> SongListNotifier = ValueNotifier([]);
  static ValueNotifier<List<SongModel>> playmodel = ValueNotifier([]);

  static addplaylist({required SongList model}) async {
    final playlistDB = await Hive.openBox<SongList>('playlist_song');
    await playlistDB.add(model);
    getplaylist();
  }

  static getplaylist() async {
    final playlistDB = await Hive.openBox<SongList>('playlist_song');
    SongListNotifier.value.clear();
    SongListNotifier.value.addAll(playlistDB.values);
    SongListNotifier.notifyListeners();
  }

  static updatelist(index, model) async {
    final playlistDB = await Hive.openBox<SongList>('playlist_song');
    await playlistDB.putAt(index, model);
    await getplaylist();
    await Songcheck.selectsong(index);
  }

  static deletePlaylist(index) async {
    final playlistDB = await Hive.openBox<SongList>('playlist_song');
    await playlistDB.deleteAt(index);
    SongListNotifier.notifyListeners();
    getplaylist();
  }
}

class Songcheck {
  static ValueNotifier<List> Playsong = ValueNotifier([]);

  static selectsong(index) async {
    final check = DBfunction.SongListNotifier.value[index].songlst;
    Playsong.value.clear();
    DBfunction.playmodel.value.clear();
    for (int i = 0; i < check.length; i++) {
      for (int j = 0; j < ScreenHome.songs.length; j++) {
        if (ScreenHome.songs[j].id == check[i]) {
          Playsong.value.add(j);
          DBfunction.playmodel.value.add(ScreenHome.songs[j]);
          break;
        }
      }
    }
  }
}
