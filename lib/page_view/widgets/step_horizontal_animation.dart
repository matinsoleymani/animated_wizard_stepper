import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_wizard_bar/colors.dart';
import 'package:animated_wizard_bar/page_view/custom_page_viewmodel.dart';
import 'package:animated_wizard_bar/page_view/wizrdbar_viewmodel.dart';

class StepHorizontalAnimation extends StatefulWidget {
  const StepHorizontalAnimation({required this.filled, required this.boxKey, required this.icon, required this.visibleLeft, required this.itemsNeedForFilled, required this.stepsNumber, this.scaleAnimation, this.iconActiveColor, this.iconDisableColor, this.lineActiveColor, this.lineDisableColor, this.boxActiveColor, this.boxDisableColor, super.key, required this.scaleAnimationList, required this.scrollController, required this.enable, this.completeColorForeground, this.completeColorBackground});

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
  double animatedContainerWidth() {
    final getWizardBarViewModel = Provider.of<WizardBarViewModel>(context);

    if (MediaQuery.sizeOf(context).width < 400) {
      if (widget.itemsNeedForFilled == getWizardBarViewModel.textFieldFilled) {
        double widthPercent = MediaQuery.sizeOf(context).width * .119;
        return widthPercent;
      } else {
        double widthPercent = (MediaQuery.sizeOf(context).width * .119) / widget.itemsNeedForFilled;
        double widthFilled = widthPercent * getWizardBarViewModel.textFieldFilled;
        return widthFilled;
      }
    } else {
      if (widget.itemsNeedForFilled == getWizardBarViewModel.textFieldFilled) {
        double widthPercent = MediaQuery.sizeOf(context).width * .128;
        return widthPercent;
      } else {
        double widthPercent = (MediaQuery.sizeOf(context).width * .128) / widget.itemsNeedForFilled;
        double widthFilled = widthPercent * getWizardBarViewModel.textFieldFilled;
        return widthFilled;
      }
    }
  }

  double boxIconSize() {
    if (MediaQuery.sizeOf(context).width < 500) {
      return MediaQuery.sizeOf(context).width * .1;
    } else {
      return MediaQuery.sizeOf(context).width * .0985;
    }
  }

  double iconSize() {
    if (MediaQuery.sizeOf(context).width >= 600) {
      return 27;
    } else {
      return 24;
    }
  }

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
    final customPageViewModel = Provider.of<CustomPageViewModel>(context);
    final getWizardBarViewModel = Provider.of<WizardBarViewModel>(context);
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IgnorePointer(
            ignoring: customPageViewModel.currentLevel == widget.stepsNumber,
            child: GestureDetector(
              onTap: () async {
                if (widget.enable == true) {
                  customPageViewModel.changeCurrentLevel(widget.stepsNumber, widget.scaleAnimationList, widget.stepsNumber, widget.boxKey, widget.scrollController);
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
                        widget.icon, //   TablerIcons.user,
                        size: iconSize(),
                        color: customPageViewModel.currentLevel - 1 >= widget.stepsNumber
                            ? widget.completeColorForeground ?? white
                            : customPageViewModel.currentLevel >= widget.stepsNumber
                                ? widget.iconActiveColor ?? const Color.fromRGBO(18, 61, 161, 1)
                                : widget.iconDisableColor ?? const Color.fromRGBO(156, 163, 175, 1.0),
                      ))),
            ),
          ),
          // Expanded(child: SizedBox()),
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
                          width: animatedContainerWidth())
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
