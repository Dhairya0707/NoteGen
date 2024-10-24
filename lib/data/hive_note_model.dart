// // ignore_for_file: depend_on_referenced_packages

import 'package:hive/hive.dart';

part 'hive_note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  String simpletxt;

  Note(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAt,
      required this.updatedAt,
      required this.simpletxt});
}

















// import 'package:hive/hive.dart';
// part 'hive_note_model.g.dart';

// // part 'package:notegen/screen/main.g.dart';
// @HiveType(typeId: 0)
// class Note {
//   @HiveField(0)
//   final String title;

//   @HiveField(1)
//   final String content;

//   @HiveField(2)
//   final DateTime createdAt;

//   @HiveField(3)
//   final DateTime updatedAt;

//   @HiveField(4)
//   final String simpletext;

//   Note({
//     required this.title,
//     required this.content,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.simpletext,
//   });
// }

