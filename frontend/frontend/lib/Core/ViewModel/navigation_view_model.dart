
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/locator.dart';

class NavigationViewModel extends ChangeNotifier {
  double mouseY = 0.0;
  double mouseX = 0.0;

  void updateContainerOnMouseUpdate(PointerEnterEvent event) {
    if (event.buttons==0) {
      mouseY = event.localPosition.dy;
      mouseX = event.localPosition.dx;
      notifyListeners();
      logger.d(event.localPosition);
    }
  }
}
