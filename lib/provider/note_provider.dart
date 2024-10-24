import 'package:flutter/material.dart';
// Import for Quill Delta
import 'package:hive/hive.dart';
import 'package:notegen/data/hive_note_model.dart';
import 'package:uuid/uuid.dart';

enum SortType { title, createdAt, updatedAt }

class NoteProvider with ChangeNotifier {
  final Box<Note> _noteBox = Hive.box<Note>('note');
  SortType _sortType = SortType.updatedAt;

  // Get all notes
  List<Note> get noteslist {
    List<Note> allNotes = _noteBox.values.toList();

    // Sort based on the current sort type
    switch (_sortType) {
      case SortType.title:
        allNotes.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortType.createdAt:
        allNotes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortType.updatedAt:
      default:
        allNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }

    return allNotes;
  }

  // Method to change the sorting order
  void changeSortType(SortType sortType) {
    _sortType = sortType;
    notifyListeners(); // Notify listeners for UI update
  }

  //get all notes read !
  // List<Note> get noteslist {
  //   List<Note> allNotes = _noteBox.values.toList();
  //   allNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  //   return allNotes;
  // }

  void chnagesort() {
    List<Note> allNotes = _noteBox.values.toList();
    allNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    noteslist.clear();
    noteslist.addAll(allNotes);
    notifyListeners();
  }

  //fetch by id
  Note fetchnote(String id) {
    var note = _noteBox.get(id);
    return note!;
  }

  //create
  Future<String> createnote() async {
    var uuid = const Uuid();
    var newNote = Note(
        id: uuid.v4(),
        title: 'New Note',
        content: r'[{"insert":"\n"},{"insert":"\n","attributes":{"header":1}}]',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        simpletxt: '');
    _noteBox.put(newNote.id, newNote);
    notifyListeners();
    return newNote.id;
  }

  //update
  void updatenote(String id, String title, String content, String simpletext) {
    var note = _noteBox.get(id);
    if (note != null) {
      note.title = title;
      note.content = content;
      note.updatedAt = DateTime.now();
      note.simpletxt = simpletext;
      _noteBox.put(note.id, note);
      notifyListeners();
    }
    notifyListeners();
  }

  //delete
  void deletenote(String id) {
    _noteBox.delete(id);
    notifyListeners();
  }

  List<Note> searchNotes(String query) {
    if (query.isEmpty) {
      return []; // Return an empty list if query is empty
    }
    return noteslist
        .where((note) =>
            note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.simpletxt.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
