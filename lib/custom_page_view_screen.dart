import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';
import 'package:animated_wizard_bar/page_view/custom_page_viewmodel.dart';
import 'package:animated_wizard_bar/page_view/widgets/custom_page_view_package.dart';
import 'package:animated_wizard_bar/page_view/widgets/step_horizontal_animation.dart';
import 'package:animated_wizard_bar/page_view/widgets/wizardbar_animation.dart';

class CustomPageViewScreen extends StatefulWidget {
  const CustomPageViewScreen({
    super.key,
  });

  @override
  State<CustomPageViewScreen> createState() => _CustomPageViewScreenState();
}

class _CustomPageViewScreenState extends State<CustomPageViewScreen> with TickerProviderStateMixin {
  final singleChildScrollControllerWizardBar = ScrollController();

  var key1 = GlobalKey();
  var key2 = GlobalKey();
  var key3 = GlobalKey();
  var key4 = GlobalKey();
  var key5 = GlobalKey();

  List<Animation<double>> animationList = [];
  List<AnimationController> aniControllerList = [];
  List<Widget> pageViewList = [
    Container(
      color: Colors.amber,
      child: const Center(
        child: Text('0'),
      ),
    ),
    const Center(
      child: Text('1'),
    ),
    const Center(
      child: Text('2'),
    ),
    const Center(
      child: Text('3'),
    ),
    const Center(
      child: Text('4'),
    ),
    // const Center(
    //   child: Text('5'),
    // )
  ];

  @override
  void initState() {
    aniControllerList = [
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
        reverseDuration: const Duration(milliseconds: 800),
      )..addListener(() {}),
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
        reverseDuration: const Duration(milliseconds: 800),
      )..addListener(() {}),
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
        reverseDuration: const Duration(milliseconds: 800),
      )..addListener(() {}),
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
        reverseDuration: const Duration(milliseconds: 800),
      )..addListener(() {}),
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
        reverseDuration: const Duration(milliseconds: 800),
      )..addListener(() {}),
    ];

    animationList = [
      Tween<double>(begin: 0.95, end: 1.35).animate(aniControllerList.elementAt(0)),
      Tween<double>(begin: 1.35, end: 0.95).animate(aniControllerList.elementAt(1)),
      Tween<double>(begin: 1.35, end: 0.95).animate(aniControllerList.elementAt(2)),
      Tween<double>(begin: 1.35, end: 0.95).animate(aniControllerList.elementAt(3)),
      Tween<double>(begin: 1.35, end: 0.95).animate(aniControllerList.elementAt(4)),
    ];
    aniControllerList.elementAt(0).forward();
    aniControllerList.elementAt(1).forward();
    aniControllerList.elementAt(2).forward();
    aniControllerList.elementAt(3).forward();
    aniControllerList.elementAt(4).forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<StepHorizontalAnimation> stepsList = [
      StepHorizontalAnimation(
        filled: true,
        boxKey: key1,
        icon: TablerIcons.user,
        visibleLeft: true,
        itemsNeedForFilled: 9,
        stepsNumber: 0,
        scaleAnimation: animationList.elementAt(0),
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        enable: false,
        // enable: true,
      ),
      StepHorizontalAnimation(
        filled: false,
        boxKey: key2,
        icon: TablerIcons.home_check,
        visibleLeft: true,
        itemsNeedForFilled: 7,
        stepsNumber: 1,
        scaleAnimation: animationList.elementAt(1),
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        enable: false,
        // enable: true,
      ),
      StepHorizontalAnimation(
        filled: false,
        boxKey: key3,
        icon: TablerIcons.briefcase,
        visibleLeft: true,
        itemsNeedForFilled: 10,
        stepsNumber: 2,
        scaleAnimation: animationList.elementAt(2),
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        enable: true,
        // enable: true,
      ),
      StepHorizontalAnimation(
        filled: false,
        boxKey: key4,
        icon: TablerIcons.users,
        visibleLeft: true,
        itemsNeedForFilled: 13,
        stepsNumber: 3,
        scaleAnimation: animationList.elementAt(3),
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        enable: false,
        // enable: true,
      ),
      StepHorizontalAnimation(
        filled: false,
        boxKey: key5,
        icon: TablerIcons.building_store,
        visibleLeft: false,
        itemsNeedForFilled: 1,
        stepsNumber: 4,
        scaleAnimation: animationList.elementAt(4),
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        enable: false,
        // enable: true,
      ),
    ];
    final getCustomPageViewModel = Provider.of<CustomPageViewModel>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        if (getCustomPageViewModel.currentLevel == 0) {
          return true;
        } else {
          getCustomPageViewModel.previousPage(aniControllerList, singleChildScrollControllerWizardBar, stepsList.length, stepsList[getCustomPageViewModel.currentLevel].boxKey);
          return false;
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: CustomPageView(
            appBar: AppBar(
              title: const Text(
                'animated wizard bar',
              ),
              centerTitle: true,
            ),
            pageViewItems: pageViewList,
            aniController: aniControllerList,
            stepsList: stepsList,
            singleChildScrollController: singleChildScrollControllerWizardBar,
            wizardBarAnimation: WizardBarAnimation(singleChildScrollControllerWizardBar, stepsList),
          ),
        ),
      ),
    );
  }
}
