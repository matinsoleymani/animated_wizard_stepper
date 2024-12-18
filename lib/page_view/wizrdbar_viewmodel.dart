import 'package:flutter/material.dart';

class WizardBarViewModel extends ChangeNotifier {
  int textFieldFilled = 1;
  bool enableStep = false;

  void initFilled() {
    textFieldFilled = 1;
    notifyListeners();
  }

  void increaseContainerSize() {
    textFieldFilled = textFieldFilled + 1;
    notifyListeners();
  }

  void decreaseContainerSize() {
    if (textFieldFilled == 1) {
    } else {
      textFieldFilled = textFieldFilled - 1;
    }
    notifyListeners();
  }

  void checkTextFieldInput(String inputText) {
    if (inputText.isEmpty) {
      decreaseContainerSize();
    } else {
      increaseContainerSize();
    }
  }
}
