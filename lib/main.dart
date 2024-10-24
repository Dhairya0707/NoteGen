import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notegen/data/hive_note_model.dart';
import 'package:notegen/provider/edit_provider.dart';
import 'package:notegen/provider/home_provider.dart';
import 'package:notegen/provider/note_provider.dart';
import 'package:notegen/provider/theme_provider.dart';
import 'package:notegen/screen/Ai_options/chat_with_ai.dart';
import 'package:notegen/screen/homepage.dart';
import 'package:notegen/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  // await Hive.openBox<Note>('notesBox');
  await Hive.openBox<Note>('note');
  await Hive.openBox('settings');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => EditProvider()),
        ChangeNotifierProvider(create: (context) => NoteProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Note-Gen',
          debugShowCheckedModeBanner: false,
          theme: NoteGenieTheme.light(),
          darkTheme: NoteGenieTheme.blueDark(),
          themeMode: themeProvider.themeMode,
          home: const Homepage(),
        );
      }),
    );
  }
}
