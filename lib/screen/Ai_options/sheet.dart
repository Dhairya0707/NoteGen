// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:notegen/data/hive_note_model.dart';
import 'package:notegen/provider/note_provider.dart';
import 'package:notegen/screen/Ai_options/chat_with_ai.dart';
import 'package:notegen/screen/Ai_options/output.dart';
import 'package:provider/provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// ignore: must_be_immutable
class AIOptionsBottomSheet extends StatelessWidget {
  String noteid;
  AIOptionsBottomSheet({super.key, required this.noteid});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDragHandle(context),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildTitle(context),
                    const SizedBox(height: 24),
                    _buildMainOptions(context),
                    const SizedBox(height: 32),
                    _buildAdditionalOptions(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Container(
      height: 5,
      width: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'AI Assistant',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMainOptions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildFeatureButton(
            context,
            'Summarize',
            Icons.summarize,
            () => _handleFeature(context, 'Summarize'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFeatureButton(
            context,
            'Rewrite',
            Icons.autorenew,
            () => _handleFeature(context, 'Rewrite'),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalOptions(BuildContext context) {
    final options = [
      ('Change Tone', Icons.mood),
      ('Spell Check', Icons.spellcheck),
      ('Grammar', Icons.abc),
      ('Make Longer', Icons.add_circle_outline), // Updated icon
      ('Make Shorter', Icons.remove_circle_outline), // New option
      ('Chat with AI', Icons.chat_bubble_outline), // Updated icon
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final (label, icon) = options[index];
        return _buildSmallFeatureButton(
          context,
          label,
          icon,
          () => _handleFeature(context, label),
        );
      },
    );
  }

  Widget _buildFeatureButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    size: 48, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallFeatureButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Material(
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 24, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFeature(BuildContext context, String feature) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    Note note = noteProvider.fetchnote(noteid);

    switch (feature) {
      case "Summarize":
        summarize(context, "Summarize", note);
        break;
      case "Rewrite":
        rewrite(context, "Rewrite", note);
        break;
      case "Change Tone":
        changetone(context, "Change Tone", note);
        break;
      case "Spell Check":
        spellchecker(context, "Spell Check", note);
      case "Grammar":
        grammarchecker(context, "Grammar", note);
        break;
      case "Make Longer":
        makelonger(context, "Make Longer", note);
        break;
      case "Make Shorter":
        makeshorter(context, "Make Shorter", note);
        break;
      case "Chat with AI":
        chatwithai(context, note);
        break;
      default:
        errorbox();
        break;
    }
    // handleAiProcess(context, noteid, note, feature);
  }

  void summarize(context, String feature, Note note) {
    String prompt =
        '''Summarize the following note into a concise and meaningful summary. Keep the core information intact while making it easy to understand. Provide a summary that aligns with the given title.
          Title: ${note.title}
          Content: ${note.simpletxt} use markdown for formatting.''';
    handleAiProcess(context, noteid, note, feature, prompt);
  }

  void rewrite(context, String feature, Note note) {
    String prompt = '''
      Rewrite the following note to improve clarity and flow while keeping the original meaning intact. Use markdown for formatting to ensure better readability. The rewritten content should align with the given title.

      **Title:** ${note.title}  
      **Content:** ${note.simpletxt}
      ''';
    handleAiProcess(context, noteid, note, feature, prompt);

    print("rewrite......");
  }

  void tonefunction(context, Note note, String tone, String feature) {
    String prompt = '''
      Rewrite the following note to match a "$tone" tone, improving clarity and flow while keeping the original meaning intact. 
      Use Markdown formatting for better readability.

      **Title:** ${note.title}  
      **Content:** ${note.simpletxt}
      ''';

    // Call the AI processing function
    handleAiProcess(context, note.id, note, feature, prompt);
  }

  void changetone(BuildContext context, String feature, Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Tone'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: const Text('Formal'),
                  onTap: () {
                    tonefunction(context, note, 'Formal', feature);
                  }),
              ListTile(
                  title: const Text('Informal'),
                  onTap: () {
                    tonefunction(context, note, 'Informal', feature);
                  }),
              ListTile(
                  title: const Text('Professional'),
                  onTap: () {
                    tonefunction(context, note, 'Professional', feature);
                  }),
              ListTile(
                  title: const Text('Casual'),
                  onTap: () {
                    tonefunction(context, note, 'Casual', feature);
                  }),
              ListTile(
                  title: const Text('Friendly'),
                  onTap: () {
                    tonefunction(context, note, 'Friendly', feature);
                  }),
            ],
          ),
        );
      },
    );
  }

  void spellchecker(context, String feature, Note note) {
    String prompt = '''
      Please check the following text for spelling errors and correct them. 
      Return the corrected content using Markdown for readability.

      **Content:** ${note.simpletxt}
      ''';

    handleAiProcess(
      context,
      note.id,
      note,
      'Spell Check',
      prompt,
    );
  }

  void grammarchecker(context, String feature, Note note) {
    String prompt = '''
        Please correct any grammatical errors in the following content while preserving the original meaning. 
        Return the corrected version using Markdown for formatting.

        **Content:** ${note.simpletxt}
        ''';

    handleAiProcess(
      context,
      note.id,
      note,
      'Grammar Correction',
      prompt,
    );
  }

  void makelonger(context, String feature, Note note) {
    String prompt = '''
      Expand the following content by adding more details, examples, or clarifications. 
      Ensure that the original meaning remains intact. Use Markdown for formatting.

      **Title:** ${note.title}  
      **Content:** ${note.simpletxt}
      ''';

    handleAiProcess(context, note.id, note, 'Make Long', prompt);
  }

  void makeshorter(context, String feature, Note note) {
    String prompt = '''
      Summarize the following content while retaining the main points. 
      Ensure the summary is concise and easy to read. Use Markdown for formatting.

      **Title:** ${note.title}  
      **Content:** ${note.simpletxt}
      ''';

    handleAiProcess(context, note.id, note, 'Make Short', prompt);
  }

  void chatwithai(context, Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatWithAiPage(
          note: note,
        ),
      ),
    );
    print("chat with ai");
  }

  void errorbox() {
    print("error box");
  }

  void handleAiProcess(BuildContext context, String noteid, Note note,
      String feature, String prompt) async {
    // Show the loading dialog
    showLoadingDialog(context);

    try {
      String? generatedContent = await fetchAiContent(prompt);
      if (generatedContent == null) return;

      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OutputPage(
            markdownContent: generatedContent,
            title: feature,
            noteid: noteid,
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to generate content: $e")),
      );
    }
  }

  Future<String?> fetchAiContent(String prompt) async {
    const apiKey = "AIzaSyCKLL1KxCeuLKh3qsYWWpWYZlryKs422I4";
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    print(response.text);
    return response.text;
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Please wait..."),
            ],
          ),
        );
      },
    );
  }
}
