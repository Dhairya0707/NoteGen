import 'package:flutter/material.dart';
import 'package:notegen/provider/home_provider.dart';
import 'package:notegen/screen/Aiinside.dart';
import 'package:notegen/screen/ProfilePage.dart';
import 'package:notegen/screen/notelist.dart';
import 'package:notegen/screen/searchpage.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
        builder: (context, HomeProvider provider, child) {
      return Scaffold(
        body: PageView(
          controller: provider.pageController,
          onPageChanged: (index) {
            setState(() {
              provider.selected = index;
            });
          },
          children: const [
            NotesPage(),
            SearchPage(),
            AIFeaturesShowcase(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          elevation: 10,
          height: MediaQuery.of(context).size.height * 0.09,
          onDestinationSelected: (int index) {
            provider.selected = index;
            provider.pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            setState(() {});
          },
          selectedIndex: provider.selected,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon: Icon(Icons.list_alt),
              label: 'My Notes',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: 'Find',
            ),
            NavigationDestination(
              icon: Icon(Icons.lightbulb_outline),
              selectedIcon: Icon(Icons.lightbulb),
              label: 'AI Tools',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      );
    });
  }
}
