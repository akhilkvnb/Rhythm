import 'package:hive_flutter/adapters.dart';
part 'model.g.dart';

@HiveType(typeId: 1)
class SongList {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<dynamic> songlst;
  SongList({required this.name, this.songlst = const []});
}
