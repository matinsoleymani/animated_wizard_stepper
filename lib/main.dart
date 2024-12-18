import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:animated_wizard_bar/custom_page_view_screen.dart';
import 'package:animated_wizard_bar/page_view/custom_page_viewmodel.dart';
import 'package:animated_wizard_bar/page_view/wizrdbar_viewmodel.dart';

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
