import 'package:animated_wizard_bar/page_view/wizrdbar_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';
import 'package:animated_wizard_bar/page_view/custom_page_viewmodel.dart';
import 'package:animated_wizard_bar/page_view/widgets/custom_page_view_package.dart';
import 'package:animated_wizard_bar/page_view/widgets/step_horizontal_animation.dart';
import 'package:animated_wizard_bar/page_view/widgets/wizardbar_animation.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  runApp(multiProvider);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleWizard(),
    );
  }
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<CustomPageViewModel>(
    create: (context) => CustomPageViewModel(),
  ),
  ChangeNotifierProvider<WizardBarViewModel>(
    create: (context) => WizardBarViewModel(),
  ),
];
MultiProvider multiProvider = MultiProvider(providers: providers, child: const MyApp());

// Example of a wizard-like UI with animated steps and a custom page view.
class ExampleWizard extends StatefulWidget {
  const ExampleWizard({super.key});

  @override
  State<ExampleWizard> createState() => _ExampleWizardState();
}

class _ExampleWizardState extends State<ExampleWizard> with TickerProviderStateMixin {
  // Scroll controller for the wizard bar, enabling horizontal scrolling.
  final singleChildScrollControllerWizardBar = ScrollController();

  // Keys to identify and manage individual steps in the wizard.
  var key1 = GlobalKey();
  var key2 = GlobalKey();
  var key3 = GlobalKey();
  var key4 = GlobalKey();
  var key5 = GlobalKey();

  // List to hold animations for scaling step indicators.
  List<Animation<double>> animationList = [];

  // List to hold animation controllers for managing the animations.
  List<AnimationController> aniControllerList = [];

  // List of widgets representing pages in the wizard.
  List<Widget> pageViewList = [
    Container(
      color: Colors.amber,
      child: const Center(
        child: Text('0'), // First page content.
      ),
    ),
    const Center(
      child: Text('1'), // Second page content.
    ),
    const Center(
      child: Text('2'), // Third page content.
    ),
    const Center(
      child: Text('3'), // Fourth page content.
    ),
    const Center(
      child: Text('4'), // Fifth page content.
    ),
  ];

  @override
  void initState() {
    // Initialize animation controllers with the same configuration.
    aniControllerList = List.generate(
      5,
      (_) => AnimationController(
        vsync: this, // Provides the Ticker for animations.
        duration: const Duration(milliseconds: 800), // Forward animation duration.
        reverseDuration: const Duration(milliseconds: 800), // Reverse animation duration.
      )..addListener(() {}), // Listener can be used for additional behavior.
    );

    // Create scale animations for each step using the animation controllers.
    animationList = aniControllerList.map((controller) {
      return Tween<double>(begin: 1.35, end: 0.95).animate(controller);
    }).toList();

    // Start all animations in the forward direction.
    for (var controller in aniControllerList) {
      controller.forward();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Define the steps for the wizard with their respective configurations.
    List<StepHorizontalAnimation> stepsList = [
      StepHorizontalAnimation(
        filled: true, // Indicates the step is completed.
        boxKey: key1, // GlobalKey for this step.
        icon: TablerIcons.user, // Icon for this step.
        visibleLeft: true, // Show divider on the left.
        itemsNeedForFilled: 9, // Threshold for marking this step as complete.
        stepsNumber: 0, // Step number.
        scaleAnimation: animationList[0], // Scaling animation for this step.
        scaleAnimationList: aniControllerList, // List of all animations.
        scrollController: singleChildScrollControllerWizardBar, // Scroll controller for the wizard bar.
        canSelect: false, // This step is not currently enabled.
      ),
      StepHorizontalAnimation(
        filled: false,
        boxKey: key2,
        icon: TablerIcons.home_check,
        visibleLeft: true,
        itemsNeedForFilled: 7,
        stepsNumber: 1,
        scaleAnimation: animationList[1],
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        canSelect: false,
      ),
      StepHorizontalAnimation(
        filled: false,
        boxKey: key3,
        icon: TablerIcons.briefcase,
        visibleLeft: true,
        itemsNeedForFilled: 10,
        stepsNumber: 2,
        scaleAnimation: animationList[2],
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        canSelect: true, // This step is enabled.
      ),
      StepHorizontalAnimation(
        filled: false,
        boxKey: key4,
        icon: TablerIcons.users,
        visibleLeft: true,
        itemsNeedForFilled: 13,
        stepsNumber: 3,
        scaleAnimation: animationList[3],
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        canSelect: false,
      ),
      StepHorizontalAnimation(
        filled: false,
        boxKey: key5,
        icon: TablerIcons.building_store,
        visibleLeft: false, // No divider on the left for the last step.
        itemsNeedForFilled: 1,
        stepsNumber: 4,
        scaleAnimation: animationList[4],
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        canSelect: false,
      ),
    ];

    // Access the CustomPageViewModel for managing page transitions.
    final getCustomPageViewModel = Provider.of<CustomPageViewModel>(context, listen: false);

    return WillPopScope(
      // Intercepts back button presses to manage wizard navigation.
      onWillPop: () async {
        if (getCustomPageViewModel.currentLevel == 0) {
          return true; // Allow back navigation if on the first step.
        } else {
          // Navigate to the previous step.
          getCustomPageViewModel.previousPage(
            aniControllerList,
            singleChildScrollControllerWizardBar,
            stepsList.length,
            stepsList[getCustomPageViewModel.currentLevel].boxKey,
          );
          return false; // Prevent default back navigation.
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: CustomPageView(
            appBar: AppBar(
              title: const Text('animated wizard bar'), // Title of the app bar.
              centerTitle: true, // Center align the title.
            ),
            pageViewItems: pageViewList, // List of pages in the wizard.
            aniController: aniControllerList, // Animation controllers for steps.
            stepsList: stepsList, // Step configurations.
            singleChildScrollController: singleChildScrollControllerWizardBar, // Scroll controller for the wizard bar.
            wizardBarAnimation: WizardBarAnimation(
              singleChildScrollControllerWizardBar, // Scroll controller.
              stepsList, // Step configurations for the wizard bar.
            ),
          ),
        ),
      ),
    );
  }
}
