import 'package:flutter/material.dart';
import 'package:notegen/screen/Ai_options/sheet.dart';

class EditProvider extends ChangeNotifier {
  String? _title;
  String? _content;

  String? get title => _title;
  String? get content => _content;

  void showAIOptionsBottomSheet(context, String noteid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AIOptionsBottomSheet(
        noteid: noteid,
      ),
    );
  }
}
