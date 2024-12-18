import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_wizard_bar/page_view/custom_page_viewmodel.dart';

PreferredSizeWidget wizardAppBar(
  BuildContext context,
  List<AnimationController> aniController,
  ScrollController singleChildScrollController,
  // List<StepHorizontalAnimation> stepsList,
  int stepsListLength,
  GlobalKey key,
) {
  return AppBar();
  // return appBarBack(context, AppRoutes.main, ()async{clickButton(context,aniController, singleChildScrollController, stepsListLength, key);}, GlobalData().checkThemeAssets(Assets.images.vam30Title.path, Assets.images.vam30TitleDark.path), 5);
}

Future<void> clickButton(
  BuildContext context,
  List<AnimationController> aniController,
  ScrollController singleChildScrollController,
  int stepsListLength,
  GlobalKey key,
) async {
  final customPageViewModel = Provider.of<CustomPageViewModel>(context, listen: false);
  customPageViewModel.previousPage(aniController, singleChildScrollController, stepsListLength, key);
}
