import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown_widget/widget/markdown.dart';

class OutputPage extends StatefulWidget {
  final String markdownContent;
  final String title;
  final String noteid;
  const OutputPage(
      {super.key,
      required this.markdownContent,
      required this.title,
      required this.noteid});

  @override
  State<OutputPage> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 10,
        actions: [
          IconButton.filled(
              onPressed: () {
                FlutterClipboard.copy(widget.markdownContent).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to Clipboard')));
                });
              },
              icon: const Icon(Icons.copy))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width,
            child: MarkdownWidget(
              data: widget.markdownContent,
              config: MarkdownConfig(configs: [
                const CodeConfig(
                    style: TextStyle(
                        backgroundColor: Color(0x002e2e2e),
                        color: Color(0x00ffffff)))
              ]),
            ),
          ),
        ),
      )),
    );
  }
}
