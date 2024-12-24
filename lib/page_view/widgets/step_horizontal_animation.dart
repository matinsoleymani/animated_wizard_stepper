import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_wizard_bar/colors.dart';
import 'package:animated_wizard_bar/page_view/custom_page_viewmodel.dart';
import 'package:animated_wizard_bar/page_view/wizrdbar_viewmodel.dart';

// This widget represents a horizontally animated step indicator with interactivity.
class StepHorizontalAnimation extends StatefulWidget {
  // Properties required to customize the widget's appearance and behavior.
  const StepHorizontalAnimation({
    required this.filled, // Whether the step is completed or filled.
    required this.boxKey, // Unique key for the box (used for animations and state management).
    required this.icon, // Icon to display inside the step indicator.
    required this.visibleLeft, // Whether the left indicator line should be visible.
    required this.itemsNeedForFilled, // Total items required to mark the step as filled.
    required this.stepsNumber, // The step number in the sequence.
    this.scaleAnimation, // Animation for scaling the icon.
    this.iconActiveColor, // Color of the icon when the step is active.
    this.iconDisableColor, // Color of the icon when the step is inactive.
    this.lineActiveColor, // Color of the line when the step is active.
    this.lineDisableColor, // Color of the line when the step is inactive.
    this.boxActiveColor, // Color of the box when the step is active.
    this.boxDisableColor, // Color of the box when the step is inactive.
    this.completeColorForeground, // Color of the foreground when the step is completed.
    this.completeColorBackground, // Color of the background when the step is completed.
    this.enable, // Whether the step is interactive (can be clicked).
    required this.scaleAnimationList, // List of animations for scaling across steps.
    required this.scrollController, // Controller for scrolling.
    super.key,
  });

  // Widget properties declaration.
  final GlobalKey boxKey;
  final IconData icon;
  final bool visibleLeft;
  final int itemsNeedForFilled;
  final int stepsNumber;
  final Animation<double>? scaleAnimation;
  final Color? completeColorForeground;
  final Color? completeColorBackground;
  final Color? iconDisableColor;
  final Color? lineDisableColor;
  final Color? boxDisableColor;
  final Color? iconActiveColor;
  final Color? lineActiveColor;
  final Color? boxActiveColor;
  final bool? filled;
  final bool? enable;
  final List<AnimationController> scaleAnimationList;
  final ScrollController scrollController;

  @override
  State<StepHorizontalAnimation> createState() => _StepHorizontalAnimationState();
}

class _StepHorizontalAnimationState extends State<StepHorizontalAnimation> {
  // Calculates the width of the animated container based on the current progress.
  double animatedContainerWidth() {
    final getWizardBarViewModel = Provider.of<WizardBarViewModel>(context);

    if (MediaQuery.sizeOf(context).width < 400) {
      // Calculate width percentage for smaller screens.
      return widget.itemsNeedForFilled == getWizardBarViewModel.textFieldFilled ? MediaQuery.sizeOf(context).width * .119 : (MediaQuery.sizeOf(context).width * .119) / widget.itemsNeedForFilled * getWizardBarViewModel.textFieldFilled;
    } else {
      // Calculate width percentage for larger screens.
      return widget.itemsNeedForFilled == getWizardBarViewModel.textFieldFilled ? MediaQuery.sizeOf(context).width * .128 : (MediaQuery.sizeOf(context).width * .128) / widget.itemsNeedForFilled * getWizardBarViewModel.textFieldFilled;
    }
  }

  // Determines the size of the box icon based on screen width.
  double boxIconSize() {
    return MediaQuery.sizeOf(context).width < 500 ? MediaQuery.sizeOf(context).width * .1 : MediaQuery.sizeOf(context).width * .0985;
  }

  // Determines the size of the step icon based on screen width.
  double iconSize() {
    return MediaQuery.sizeOf(context).width >= 600 ? 27 : 24;
  }

  // Determines the color of the indicator line based on the current step state.
  Color indicatorColor() {
    final customPageViewModel = Provider.of<CustomPageViewModel>(context);

    if (customPageViewModel.currentLevel - 1 >= widget.stepsNumber) {
      return widget.boxActiveColor ?? primary600;
    } else if (widget.filled == true && customPageViewModel.currentLevel >= widget.stepsNumber) {
      return widget.boxActiveColor ?? primaryColor;
    } else {
      return widget.iconDisableColor ?? const Color.fromRGBO(156, 163, 175, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ViewModels for managing state and animations.
    final customPageViewModel = Provider.of<CustomPageViewModel>(context);
    final getWizardBarViewModel = Provider.of<WizardBarViewModel>(context);

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Interactive box representing a step.
          IgnorePointer(
            ignoring: customPageViewModel.currentLevel == widget.stepsNumber,
            child: GestureDetector(
              onTap: () {
                if (widget.enable == true) {
                  customPageViewModel.changeCurrentLevel(
                    widget.stepsNumber,
                    widget.scaleAnimationList,
                    widget.stepsNumber,
                    widget.boxKey,
                    widget.scrollController,
                  );
                  getWizardBarViewModel.initFilled();
                }
              },
              child: AnimatedContainer(
                key: widget.boxKey,
                duration: const Duration(milliseconds: 500),
                width: customPageViewModel.currentLevel == widget.stepsNumber ? boxIconSize() + 2 : boxIconSize() - 1,
                height: customPageViewModel.currentLevel == widget.stepsNumber ? 60 : 36,
                decoration: BoxDecoration(
                  color: customPageViewModel.currentLevel - 1 >= widget.stepsNumber
                      ? widget.completeColorForeground ?? primary600
                      : customPageViewModel.currentLevel >= widget.stepsNumber
                          ? widget.boxActiveColor ?? const Color.fromRGBO(239, 247, 255, 1.0)
                          : widget.boxDisableColor ?? const Color.fromRGBO(243, 244, 246, 1.0),
                  shape: BoxShape.circle,
                ),
                child: ScaleTransition(
                  scale: widget.scaleAnimation!,
                  child: Icon(
                    widget.icon,
                    size: iconSize(),
                    color: customPageViewModel.currentLevel - 1 >= widget.stepsNumber
                        ? widget.completeColorForeground ?? white
                        : customPageViewModel.currentLevel >= widget.stepsNumber
                            ? widget.iconActiveColor ?? const Color.fromRGBO(18, 61, 161, 1)
                            : widget.iconDisableColor ?? const Color.fromRGBO(156, 163, 175, 1.0),
                  ),
                ),
              ),
            ),
          ),
          // Line connecting steps (if applicable).
          Visibility(
            visible: widget.visibleLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * .025),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width < 400 ? MediaQuery.sizeOf(context).width * 0.119 : MediaQuery.sizeOf(context).width * .128,
                height: 2,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      color: indicatorColor(),
                      height: 2,
                      width: MediaQuery.sizeOf(context).width < 400 ? MediaQuery.sizeOf(context).width * 0.119 : MediaQuery.sizeOf(context).width * .128,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: customPageViewModel.currentLevel - 1 >= widget.stepsNumber
                          ? widget.completeColorForeground ?? primary600
                          : customPageViewModel.currentLevel >= widget.stepsNumber
                              ? widget.lineActiveColor ?? const Color.fromRGBO(18, 61, 161, 1)
                              : Colors.transparent,
                      height: 2,
                      width: animatedContainerWidth(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
