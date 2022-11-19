import 'package:flutter/cupertino.dart';

class LeftBarViewModel extends ChangeNotifier {
  int _selectedIndex = 0;

  set selectedIndex(value) {
    _selectedIndex = value;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;

  
}
