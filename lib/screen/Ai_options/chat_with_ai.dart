import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:notegen/data/hive_note_model.dart';

class ChatWithAiPage extends StatefulWidget {
  final Note note;

  ChatWithAiPage({super.key, required this.note});

  @override
  State<ChatWithAiPage> createState() => _ChatWithAiPageState();
}

class _ChatWithAiPageState extends State<ChatWithAiPage> {
  final List<ChatMessage> _messages = [];
  final _user = ChatUser(id: 'user-1');
  final _gemini = ChatUser(id: 'user-2', firstName: 'AI Assistant');
  late final ChatSession _session;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    String instruction =
        '''You are assisting the user based on the following note. Keep the conversation relevant to the note's content and context. Answer concisely, and use Markdown for formatting your response.
          Note Title: ${widget.note.title} 
          Note Content: ${widget.note.simpletxt}
          System Instructions:
          - Focus only on the topic or details mentioned in the note.
          - If the user asks for clarification or expansion, use the note content to generate your response.
          - If a question is off-topic, politely bring the conversation back to the note's context.
          - Use bullet points, headings, or bold text in your response when appropriate.''';

    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: "AIzaSyCKLL1KxCeuLKh3qsYWWpWYZlryKs422I4",
      systemInstruction: Content.text(instruction),
      generationConfig: GenerationConfig(maxOutputTokens: 1000),
    );
    _session = model.startChat();
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.insert(0, message);
      _isTyping = false;
    });
  }

  Future<void> _handleSendPressed(ChatMessage message) async {
    if (message.text.isEmpty) return;

    _addMessage(message);
    aichat(message.text);
  }

  void aichat(String textMessage) async {
    setState(() {
      _isTyping = true;
    });

    final content = Content.text(textMessage);
    final response = await _session.sendMessage(content);

    final aiMessage = ChatMessage(
      user: _gemini,
      text: response.text!,
      createdAt: DateTime.now(),
    );

    _addMessage(aiMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show help or information about using the chat
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Help"),
                  content:
                      const Text("You can ask questions related to your note."),
                  actions: [
                    TextButton(
                      child: const Text("Close"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              currentUser: _user,
              messages: _messages,
              onSend: _handleSendPressed,
              typingUsers: [
                if (_isTyping) _gemini,
              ],
              inputOptions: InputOptions(
                inputDecoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
                alwaysShowSend: true,
                // inputTextStyle: const TextStyle(color: Colors.black),
                sendButtonBuilder: (send) => IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: send,
                ),
              ),
              messageOptions: const MessageOptions(
                showCurrentUserAvatar: false,
                showOtherUsersAvatar: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Note Title: ${widget.note.title}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
