// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:notegen/data/hive_note_model.dart';
// import 'package:notegen/provider/note_provider.dart';
// import 'package:notegen/screen/editpage.dart';
// import 'package:provider/provider.dart';

// class HomeProvider extends ChangeNotifier {
//   PageController pageController = PageController();
//   int selected = 0;
//   Box<Note>? _notesBox;

//   Future<void> init() async {
//     _notesBox = Hive.box<Note>('notesBox');
//   }

//   List<Note> get notes => _notesBox?.values.toList() ?? [];

//   Future<void> createnote(context) async {
//     final noteProvider = Provider.of<NoteProvider>(context, listen: false);
//     final newNote = Note(
//       title: 'Untitled',
//       content: '',
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//       simpletext: '',
//     );

//     final noteIndex = await noteProvider.addNote(newNote);

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => NoteEditPage(noteIndex: noteIndex),
//       ),
//     );
//   }
// }
