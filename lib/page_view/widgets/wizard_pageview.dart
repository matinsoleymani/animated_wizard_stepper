import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_wizard_bar/colors.dart';
import 'package:animated_wizard_bar/page_view/custom_page_viewmodel.dart';
import 'package:animated_wizard_bar/page_view/widgets/step_horizontal_animation.dart';
import 'package:animated_wizard_bar/page_view/widgets/wizardbar_animation.dart';

// A custom widget to create a page view with a wizard bar and optional top container, buttons, and app bar.
class WizardPageView extends StatefulWidget {
  // Animation controllers for handling step animations.
  final List<AnimationController> aniController;

  // Scroll controller for managing scrolling within the page view.
  final ScrollController singleChildScrollController;

  // List of step widgets for the wizard bar.
  final List<StepHorizontalAnimation> stepsList;

  // The wizard bar animation widget.
  final WizardBarAnimation wizardBarAnimation;

  // An optional container to display at the top of the page.
  final Container? containerTopOfPage;

  // Optional widgets for the "first" and "second" buttons.
  final Widget? firstButton;
  final Widget? secondButton;

  // App bar for the page view.
  final PreferredSizeWidget appBar;

  // List of widgets to be displayed as pages in the page view.
  final List<Widget> pageViewItems;

  // Constructor for the custom page view widget.
  const WizardPageView({
    super.key,
    required this.appBar,
    required this.pageViewItems,
    required this.aniController,
    required this.singleChildScrollController,
    required this.wizardBarAnimation,
    this.containerTopOfPage,
    this.firstButton,
    this.secondButton,
    required this.stepsList,
  });

  @override
  State<WizardPageView> createState() => _WizardPageViewState();
}

// The state class for CustomPageView, handling animations and page transitions.
class _WizardPageViewState extends State<WizardPageView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // Accessing the CustomPageViewModel via the Provider package for state management.
    final customPageViewModel = Provider.of<CustomPageViewModel>(context);

    return Scaffold(
      // Display the provided app bar.
      appBar: widget.appBar,
      backgroundColor: Colors.green, // Sets the background color for the entire scaffold.
      body: Stack(
        // Combines multiple widgets into layers (wizard bar, pages, and buttons).
        children: [
          wizardBar(), // Wizard bar at the top.
          pages(customPageViewModel), // Page view in the middle.
          bottomButtons(customPageViewModel, context, () {}), // Bottom buttons.
        ],
      ),
    );
  }

  // Widget to display the wizard bar at the top of the page.
  Container wizardBar() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // Background color matching the theme.
      child: Column(
        children: [
          const SizedBox(height: 18), // Adds spacing before the wizard bar.
          widget.wizardBarAnimation, // Displays the wizard bar animation.
        ],
      ),
    );
  }

  // Widget to display the page view in the center of the page.
  Positioned pages(CustomPageViewModel customPageViewModel) {
    return Positioned.fill(
      top: 72, // Adds spacing at the top of the page view.
      bottom: 62, // Adds spacing at the bottom of the page view.
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(), // Disables direct user scrolling.
        itemCount: widget.pageViewItems.length, // Total number of pages.
        itemBuilder: (context, index) {
          return widget.pageViewItems[index]; // Builds each page.
        },
        padEnds: true, // Adds padding to the edges of the pages.
        scrollDirection: Axis.horizontal, // Sets the page view to scroll horizontally.
        controller: customPageViewModel.pageViewController, // Uses a controller for programmatic scrolling.
      ),
    );
  }

  // Widget to display buttons at the bottom of the page.
  Positioned bottomButtons(CustomPageViewModel customPageViewModel, BuildContext context, Function onPress) {
    return Positioned(
      height: 64, // Fixed height for the bottom button area.
      bottom: 0, // Positioned at the bottom of the screen.
      right: 0,
      left: 0,
      child: AnimatedContainer(
        duration: const Duration(seconds: 1), // Animation duration for smooth transitions.
        width: double.infinity, // Occupies the full width of the screen.
        height: 64,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: gray400.withOpacity(0.4), // Adds a subtle shadow for elevation.
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
          color: white, // Background color for the button area.
        ),
        child: Row(
          mainAxisAlignment: customPageViewModel.currentLevel == 5
              ? MainAxisAlignment.center // Centers the button if on the last level.
              : MainAxisAlignment.spaceEvenly, // Spreads buttons evenly otherwise.
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Second button or "Back" button if not provided.
            widget.secondButton ??
                InkWell(
                  onTap: () {
                    // Navigates to the previous page.
                    customPageViewModel.previousPage(
                      widget.aniController,
                      widget.singleChildScrollController,
                      widget.stepsList.length,
                      widget.stepsList[customPageViewModel.currentLevel].boxKey,
                    );
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.sizeOf(context).width * 0.35, // Button width relative to screen size.
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Transparent background.
                      border: Border.all(color: Colors.black, width: 1), // Black border.
                      borderRadius: BorderRadius.circular(24), // Rounded corners.
                    ),
                    child: const Center(child: Text('back')), // "Back" button label.
                  ),
                ),
            // If not on the last level, display the "Next" button.
            customPageViewModel.currentLevel == 5
                ? const SizedBox() // Empty widget if on the last level.
                : widget.firstButton ??
                    InkWell(
                      onTap: () {
                        // Navigates to the next page.
                        customPageViewModel.nextPage(
                          widget.aniController,
                          widget.singleChildScrollController,
                          widget.stepsList.length,
                          widget.stepsList[customPageViewModel.currentLevel].boxKey,
                          context,
                        );
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.sizeOf(context).width * 0.35, // Button width relative to screen size.
                        decoration: BoxDecoration(
                          color: primaryColor, // Primary color for the button.
                          borderRadius: BorderRadius.circular(24), // Rounded corners.
                        ),
                        child: const Center(
                          child: Text(
                            'next',
                            style: TextStyle(color: Colors.white), // White text color.
                          ),
                        ),
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}
