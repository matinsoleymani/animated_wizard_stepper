import 'package:animated_wizard_bar/page_view/widgets/wizard_textfield.dart';
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
// ***** ] know this code is not clean ذut I wanted to keep all the classes in one place for your convenience so you can test more easily. *****

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
    const IdentityScreen(),
    const Residential(),
    const Persons(),
    const Center(
      child: Text('. filled'), // Fourth page content.
    ),
    const Center(
      child: Text('. finish'), // Fifth page content.
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

    animationList = aniControllerList.asMap().entries.map((entry) {
      int index = entry.key;
      AnimationController controller = entry.value;
      if (index == 0) {
        return Tween<double>(begin: 0.95, end: 1.35).animate(controller);
      } else {
        return Tween<double>(begin: 1.35, end: 0.95).animate(controller);
      }
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
        filled: false, // Indicates the step is completed.
        boxKey: key1, // GlobalKey for this step.
        icon: TablerIcons.user, // Icon for this step.
        visibleLeft: true, // Show divider on the left.
        itemsNeedForFilled: 6, // Threshold for marking this step as complete +1.
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
        itemsNeedForFilled: 3,
        stepsNumber: 1,
        scaleAnimation: animationList[1],
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        canSelect: true,
      ),
      StepHorizontalAnimation(
        filled: false,
        boxKey: key3,
        icon: TablerIcons.briefcase,
        visibleLeft: true,
        itemsNeedForFilled: 2,
        stepsNumber: 2,
        scaleAnimation: animationList[2],
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        canSelect: true, // This step is enabled.
      ),
      StepHorizontalAnimation(
        filled: true,
        boxKey: key4,
        icon: TablerIcons.users,
        visibleLeft: true,
        itemsNeedForFilled: 13,
        stepsNumber: 3,
        scaleAnimation: animationList[3],
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        canSelect: true,
      ),
      StepHorizontalAnimation(
        filled: true,
        boxKey: key5,
        icon: TablerIcons.building_store,
        visibleLeft: false, // No divider on the left for the last step.
        itemsNeedForFilled: 1,
        stepsNumber: 4,
        scaleAnimation: animationList[4],
        scaleAnimationList: aniControllerList,
        scrollController: singleChildScrollControllerWizardBar,
        canSelect: true,
      ),
    ];

    // Access the CustomPageViewModel for managing page transitions.
    final getCustomPageViewModel = Provider.of<CustomPageViewModel>(context, listen: false);

    return PopScope(
      // Intercepts back button presses to manage wizard navigation.
      canPop: getCustomPageViewModel.currentLevel == 0,

      // onWillPop: () async {
      //   if (getCustomPageViewModel.currentLevel == 0) {
      //     return true; // Allow back navigation if on the first step.
      //   } else {
      //     // Navigate to the previous step.
      //     getCustomPageViewModel.previousPage(
      //       aniControllerList,
      //       singleChildScrollControllerWizardBar,
      //       stepsList.length,
      //       stepsList[getCustomPageViewModel.currentLevel].boxKey,
      //     );
      //     return false; // Prevent default back navigation.
      //   }
      // },
      child: SafeArea(
        child: Scaffold(
          body: CustomPageView(
            appBar: AppBar(
              title: const Text(
                'animated wizard bar',
                style: TextStyle(color: Colors.black),
              ), // Title of the app bar.
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

// ignore: must_be_immutable
class IdentityScreen extends StatefulWidget {
  const IdentityScreen({super.key});

  @override
  State<IdentityScreen> createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  final formKeyName = GlobalKey<FormState>();

  final formKeyLastName = GlobalKey<FormState>();

  final formKeyNationalId = GlobalKey<FormState>();

  final formKeyPhoneNumber = GlobalKey<FormState>();

  final formKeyFatherName = GlobalKey<FormState>();

  final FocusNode focusNodeName = FocusNode();

  final FocusNode focusNodeLastName = FocusNode();

  final FocusNode focusNodeNationalId = FocusNode();

  final FocusNode focusNodePhoneNumber = FocusNode();

  final FocusNode focusNodeFatherName = FocusNode();

  TextEditingController nameValue = TextEditingController();

  TextEditingController lastNameValue = TextEditingController();

  TextEditingController nationalIdValue = TextEditingController();

  TextEditingController phoneNumberValue = TextEditingController();

  TextEditingController fatherNameValue = TextEditingController();

  final List<String> items = [
    '',
    'first',
    'second'
  ];

  String lastTextOfName = '';

  String lastTextOFLastName = '';

  String lastTextOFNationalId = '';

  String lastTextOFFatherName = '';

  String lastTextOFPhoneNumber = '';

  @override
  void initState() {
    lastTextOfName = '';
    lastTextOFLastName = '';
    lastTextOFNationalId = '';
    lastTextOFFatherName = '';
    lastTextOFPhoneNumber = '';

    nameValue.text = '';
    lastNameValue.text = '';
    nationalIdValue.text = '';
    phoneNumberValue.text = '';
    fatherNameValue.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Fill in the required information',
                style: TextStyle(fontSize: 16),
              ),
              WizardTextField(
                  args: WizardTextFieldArguments(
                keyTextField: formKeyName,
                focusNode: focusNodeName,
                textEditingController: nameValue,
                label: 'name',
                enable: true,
                valueChanged: () {
                  lastTextOfName = nameValue.text;
                },
              )),
              WizardTextField(
                  args: WizardTextFieldArguments(
                keyTextField: formKeyLastName,
                focusNode: focusNodeLastName,
                textEditingController: lastNameValue,
                label: 'last name',
                enable: true,
                valueChanged: () {
                  lastTextOFLastName = lastNameValue.text;
                },
              )),
              WizardTextField(
                  args: WizardTextFieldArguments(
                keyTextField: formKeyNationalId,
                focusNode: focusNodeNationalId,
                textEditingController: nationalIdValue,
                label: 'national id',
                enable: true,
                valueChanged: () {
                  lastTextOFNationalId = nationalIdValue.text;
                },
              )),
              WizardTextField(
                  args: WizardTextFieldArguments(
                keyTextField: formKeyFatherName,
                focusNode: focusNodeFatherName,
                textEditingController: fatherNameValue,
                label: 'father name',
                enable: true,
                valueChanged: () {
                  lastTextOFFatherName = fatherNameValue.text;
                },
              )),
              WizardTextField(
                  args: WizardTextFieldArguments(
                keyTextField: formKeyPhoneNumber,
                focusNode: focusNodePhoneNumber,
                textEditingController: phoneNumberValue,
                label: 'phone number',
                enable: true,
                valueChanged: () {
                  lastTextOFPhoneNumber = phoneNumberValue.text;
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class Residential extends StatefulWidget {
  const Residential({super.key});

  @override
  State<Residential> createState() => _ResidentialState();
}

class _ResidentialState extends State<Residential> {
  List<String> continents = [
    '',
    'Europe',
    'Asia',
    'Africa',
    'North America',
    'South America',
    'Oceania',
    'Antarctica',
  ];

  List<String> ageRange = [
    '',
    '15 - 20',
    '20 - 25',
    '25 - 30',
    '30 - 35',
  ];

  String lastTextOfContinents = '';

  String lastTextOfAgeRange = '';

  @override
  void initState() {
    lastTextOfContinents = '';
    lastTextOfAgeRange = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Which continent are you from ?',
                textDirection: TextDirection.ltr,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                items: continents
                    .map((i) => DropdownMenuItem(
                        value: i,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              i,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "IranYekan",
                              ),
                            ))))
                    .toList(),
                onChanged: (value) {
                  if (value == '' && lastTextOfContinents != '') {
                    final getWizardPageViewModel = Provider.of<WizardBarViewModel>(context, listen: false);
                    getWizardPageViewModel.decreaseContainerSize();
                  } else if (value != '' && lastTextOfContinents == '') {
                    final getWizardPageViewModel = Provider.of<WizardBarViewModel>(context, listen: false);
                    getWizardPageViewModel.increaseContainerSize();
                  }
                  lastTextOfContinents = value ?? '';
                },
              ),
              const Text(
                'What is your age range?',
                textDirection: TextDirection.ltr,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                items: ageRange
                    .map((i) => DropdownMenuItem(
                        value: i,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              i,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "IranYekan",
                              ),
                            ))))
                    .toList(),
                onChanged: (value) {
                  if (value == '' && lastTextOfAgeRange != '') {
                    final getWizardPageViewModel = Provider.of<WizardBarViewModel>(context, listen: false);
                    getWizardPageViewModel.decreaseContainerSize();
                  } else if (value != '' && lastTextOfAgeRange == '') {
                    final getWizardPageViewModel = Provider.of<WizardBarViewModel>(context, listen: false);
                    getWizardPageViewModel.increaseContainerSize();
                  }
                  lastTextOfAgeRange = value ?? '';
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Persons extends StatefulWidget {
  const Persons({super.key});

  @override
  State<Persons> createState() => _PersonsState();
}

class _PersonsState extends State<Persons> {
  int radioValue = 0;

  String _selectedValue = ''; // Currently selected value

  final List<String> _options = [
    'Option 1',
    'Option 2',
  ];

  @override
  void initState() {
    _selectedValue = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'choose one of options ?',
                textDirection: TextDirection.ltr,
              ),
              // for (int index = 0; index < 1; ++index)
              // Radio(
              //   value: index, groupValue: radioValue, onChanged: handleRadioValueChanged),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _options.map((option) {
                    return Row(
                      children: [
                        Radio<String>(
                          value: option,
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            if (value == '' && _selectedValue != '') {
                              final getWizardPageViewModel = Provider.of<WizardBarViewModel>(context, listen: false);
                              getWizardPageViewModel.decreaseContainerSize();
                            } else if (value != '' && _selectedValue == '') {
                              final getWizardPageViewModel = Provider.of<WizardBarViewModel>(context, listen: false);
                              getWizardPageViewModel.increaseContainerSize();
                            }
                            setState(() {
                              _selectedValue = value ?? '';
                            });
                          },
                        ),
                        Text(option),
                      ],
                    );
                  }).toList(),
                ),
              ),
              // RadioMenuButton(value: index, groupValue: radioValue, onChanged: handleRadioValueChanged, child: Text(index.toString()))
            ],
          ),
        ),
      ),
    );
  }
}
