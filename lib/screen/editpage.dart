// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notegen/data/hive_note_model.dart';
import 'package:notegen/provider/edit_provider.dart';
import 'package:notegen/provider/note_provider.dart';
import 'package:provider/provider.dart';

class NoteEditPage extends StatefulWidget {
  final String id;
  const NoteEditPage({super.key, required this.id});

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  bool isreadonly = false;
  quill.QuillController controller = quill.QuillController.basic();
  TextEditingController titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _bodyFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final Note note = noteProvider.fetchnote(widget.id);

    loadnote(note);

    titleController.addListener(() {
      updatenotes();
    });

    controller.addListener(() {
      updatenotes();
    });
  }

  void loadnote(Note note) {
    titleController.text = note.title;
    final editdata = jsonDecode(note.content);
    controller.document = Document.fromJson(editdata);
  }

  void updatenotes() {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final updatedTitle = titleController.text;
    final content = controller.document;
    final updatedcontent = jsonEncode(content.toDelta().toJson());
    final simpletext = content.toPlainText();
    final id = widget.id;
    noteProvider.updatenote(id, updatedTitle, updatedcontent, simpletext);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: 'Back',
          ),
          actions: [
            Tooltip(
              message: controller.readOnly ? 'Edit' : 'Lock',
              child: IconButton(
                icon:
                    Icon(controller.readOnly ? Icons.lock : Icons.edit_rounded),
                onPressed: () {
                  setState(() {
                    isreadonly = !isreadonly;
                    controller.readOnly = isreadonly;
                  });
                },
              ),
            ),
            Tooltip(
              message: 'AI Menu',
              child: IconButton.filled(
                onPressed: () {
                  provider.showAIOptionsBottomSheet(context, widget.id);
                },
                icon: const Icon(Icons.auto_awesome),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Delete',
                      ),
                    ],
                  ),
                  onTap: () {
                    final noteProvider =
                        Provider.of<NoteProvider>(context, listen: false);
                    _showDeleteConfirmation(context, noteProvider, widget.id);
                  },
                ),
              ],
            ),
          ],
          title: TextField(
            focusNode: _titleFocusNode,
            controller: titleController,
            onSubmitted: (text) {},
            onChanged: (text) {},
            decoration: const InputDecoration(
              hintText: 'Enter title',
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            enabled: !isreadonly,
          ),
        ),
        body: Column(
          children: [
            if (!controller.readOnly)
              quill.QuillToolbar.simple(
                controller: controller,
                configurations: const quill.QuillSimpleToolbarConfigurations(
                  fontSizesValues: {
                    "small": "12",
                    "normal": "16",
                    "medium": "20",
                    "large": "24",
                    "huge": "32"
                  },

                  multiRowsDisplay: false,
                  showColorButton: false,

                  showDirection: false,
                  showClipboardCopy: false,
                  showClipboardCut: false,
                  showClipboardPaste: false,
                  showStrikeThrough: false,
                  // showQuote: false,
                  showIndent: false,
                  showSuperscript: false,
                  showSubscript: false,
                  showBackgroundColorButton: false,
                  showAlignmentButtons: false,
                  showSmallButton: false,
                  showFontFamily: false,
                  showInlineCode: false,
                  toolbarIconAlignment: WrapAlignment.start,
                  toolbarIconCrossAlignment: WrapCrossAlignment.start,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _titleFocusNode.unfocus();
                    _bodyFocusNode.requestFocus();
                  },
                  child: quill.QuillEditor.basic(
                    focusNode: _bodyFocusNode,

                    configurations: const quill.QuillEditorConfigurations(
                      showCursor: true,
                      autoFocus: false,
                      scrollable: true,
                    ),

                    controller: controller,
                    // readOnly: _controller.readOnly,
                  ),
                ),
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: true,
      );
    });
  }

  void _showDeleteConfirmation(
      BuildContext context, NoteProvider provider, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Note"),
          content: const Text("Are you sure you want to delete this note?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                provider.deletenote(id);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
