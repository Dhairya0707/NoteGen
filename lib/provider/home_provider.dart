import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  PageController pageController = PageController(initialPage: 0);
  int selected = 0;
}
