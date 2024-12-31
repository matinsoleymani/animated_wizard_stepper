import 'package:flutter/material.dart';
import 'package:animated_wizard_bar/page_view/widgets/step_horizontal_animation.dart';

// A widget that provides an animated wizard bar with horizontally scrollable steps.
class WizardBarAnimation extends StatefulWidget {
  // Scroll controller to manage horizontal scrolling.
  final ScrollController? scrollController;

  // List of step items (StepHorizontalAnimation widgets) to be displayed in the wizard bar.
  final List<StepHorizontalAnimation> stepItems;

  // Constructor for the widget. Takes a scroll controller and a list of step items.
  const WizardBarAnimation(this.scrollController, this.stepItems, {super.key});

  @override
  State<WizardBarAnimation> createState() => _WizardBarAnimationState();
}

class _WizardBarAnimationState extends State<WizardBarAnimation> {
  @override
  void initState() {
    super.initState();
    // Initial setup logic can go here, if needed in the future.
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Adds padding to the top, left, and right of the wizard bar.
      padding: const EdgeInsets.only(top: 0, right: 12, left: 12),
      child: SizedBox(
        height: 46, // Fixed height for the wizard bar.
        child: Center(
          // Centers the content vertically within the container.
          child: ListView.builder(
            // Adds bouncing physics for a smooth scrolling experience.
            physics: const BouncingScrollPhysics(),
            // Uses the provided scroll controller for horizontal scrolling.
            controller: widget.scrollController,
            // Sets the scroll direction to horizontal.
            scrollDirection: Axis.horizontal,
            // Number of items to display in the wizard bar.
            itemCount: widget.stepItems.length,
            // Shrinks the view to only occupy the necessary space.
            shrinkWrap: true,
            // Builds each item (step) in the wizard bar.
            itemBuilder: (context, index) {
              return widget.stepItems[index]; // Displays the corresponding step item.
            },
          ),
        ),
      ),
    );
  }
}
