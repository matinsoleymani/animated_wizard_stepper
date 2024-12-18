import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_wizard_bar/page_view/wizrdbar_viewmodel.dart';

class CustomPageViewModel extends ChangeNotifier {
  int currentLevel = 0;
  int textFieldFilled = 1;
  bool enableStep = false;
  int textFieldField = 0;
  bool enableButton = false;

  final pageViewController = PageController();

  List<AnimationController>? animationController;
  ScrollController? singleScrollController;
  int? stepsLength;
  GlobalKey? globalKey;

  void initCurrentLevel() {
    currentLevel = 0;
    notifyListeners();
  }

  changeCurrentLevel(int levelNumber, List<AnimationController> aniController, int stepsListLength, GlobalKey key, ScrollController singleChildScrollController) async {
    animationController = aniController;
    stepsLength = stepsListLength;
    singleScrollController = singleChildScrollController;
    globalKey = key;
    notifyListeners();
    toggleScaleSelect(aniController, levelNumber);
    await Future.delayed(const Duration(milliseconds: 100));
    currentLevel = levelNumber;
    if (levelNumber <= 2) {
      previusScrollListener(singleChildScrollController, key);
    } else {
      nextScrollListener(singleChildScrollController, key);
    }

    // nextScrollListener(singleChildScrollController, key);
    if (pageViewController.hasClients) {
      pageViewController.jumpToPage(levelNumber);
    }

    notifyListeners();
  }

  void toggleScaleSelect(List<AnimationController> aniController, int levelNumber) {
    // if (currentLevel == 0) {
    if (currentLevel == 0) {
      aniController.elementAt(currentLevel).reverse();
      aniController.elementAt(levelNumber).reverse();
    } else if (levelNumber == 0) {
      aniController.elementAt(currentLevel).forward();
      aniController.elementAt(levelNumber).forward();
    } else {
      aniController.elementAt(currentLevel).forward();
      aniController.elementAt(levelNumber).reverse();
    }
  }

  Future<void> nextPage(
      List<AnimationController> aniController,
      ScrollController singleChildScrollController,
      // List<StepHorizontalAnimation> stepsList,
      int stepsListLength,
      GlobalKey key,
      BuildContext context) async {
    animationController = aniController;
    stepsLength = stepsListLength;
    singleScrollController = singleChildScrollController;
    globalKey = key;
    notifyListeners();
    final getWizardBarViewModel = Provider.of<WizardBarViewModel>(context, listen: false);
    if (currentLevel < stepsListLength - 1 && enableButton == false) {
      // print(currentLevel);
      enableButton = true;
      notifyListeners();
      try {
        // await apiCallPage(currentLevel, context);
        await Future.delayed(const Duration(milliseconds: 400));
        // if(enableNextPage()==true){
        currentLevel = currentLevel + 1;
        textFieldFilled = 1;
        // enableButton=true;
        notifyListeners();
        pageViewController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.linear,
        );
        nextScrollListener(singleChildScrollController, key);

        toggleScale(aniController, stepsListLength);

        await Future.delayed(const Duration(milliseconds: 300));
        enableButton = false;
        notifyListeners();
        // }
      } catch (e) {
        await Future.delayed(const Duration(milliseconds: 300));
        enableButton = false;
        notifyListeners();
        // throw Exception();
      }
      getWizardBarViewModel.initFilled();
    }
    // print(currentLevel);
  }

  Future<void> previousPage(
    List<AnimationController> aniController,
    ScrollController singleChildScrollController,
    // List<StepHorizontalAnimation> stepsList,
    int stepsListLength,
    GlobalKey key,
  ) async {
    if (currentLevel > 0 && enableButton == false) {
      currentLevel = currentLevel - 1;
      enableButton = true;
      notifyListeners();
      pageViewController.previousPage(duration: const Duration(milliseconds: 600), curve: Curves.linear);
      previusScrollListener(singleChildScrollController, key);

      toggleScale(aniController, stepsListLength);
      // print("currentLevel: $currentLevel");
      await Future.delayed(const Duration(milliseconds: 300));
      enableButton = false;
      notifyListeners();
    } else if (enableButton == false) {
      // print("currentLevel: $currentLevel");
      await Future.delayed(const Duration(milliseconds: 300));
      enableButton = false;
      notifyListeners();
    }
  }

  ScrollController scrollController = ScrollController();
  bool invisible = false;

  void hideLevelScroll() {
    scrollController.addListener(() {
      if (scrollController.offset >= 20) {
        invisible = true;
        notifyListeners();
      }
    });
    scrollController.addListener(() {
      if (scrollController.offset < 20) {
        invisible = false;
        notifyListeners();
      }
    });
  }

  void increaseContainerSize() {
    textFieldFilled = textFieldFilled + 1;
    notifyListeners();
  }

  void decreaseContainerSize() {
    textFieldFilled = textFieldFilled - 1;
    notifyListeners();
  }

  void checkTextFieldInput(String inputText) {
    if (inputText.isEmpty) {
      decreaseContainerSize();
    } else if (inputText.length <= 1) {
      increaseContainerSize();
    }
  }

  void toggleScale(List<AnimationController> aniController, int stepListLength) {
    if (currentLevel == 0) {
      aniController.elementAt(currentLevel).forward();
      aniController.elementAt(currentLevel + 1).forward();
    } else if (stepListLength == currentLevel) {
      aniController.elementAt(currentLevel - 1).forward();
      aniController.elementAt(currentLevel).reverse();
    } else if (currentLevel == 1) {
      aniController.elementAt(currentLevel - 1).reverse();
      aniController.elementAt(currentLevel).reverse();
      aniController.elementAt(currentLevel + 1).forward();
    } else {
      aniController.elementAt(currentLevel - 1).forward();
      aniController.elementAt(currentLevel).reverse();
      aniController.elementAt(currentLevel + 1).forward();
    }
  }

  void nextScrollListener(
    ScrollController singleChildScrollController,
    GlobalKey key,
  ) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void previusScrollListener(
    ScrollController singleChildScrollController,
    GlobalKey key,
  ) {
    // print(key.currentContext!);
    Scrollable.ensureVisible(
      key.currentContext!, alignment: 1,
      // alignment: 0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
}
