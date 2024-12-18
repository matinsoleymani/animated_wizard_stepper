import 'package:flutter/material.dart';
import 'package:animated_wizard_bar/page_view/widgets/step_horizontal_animation.dart';

class WizardBarAnimation extends StatefulWidget {
  final ScrollController? scrollController;
  final List<StepHorizontalAnimation> stepItems;

  const WizardBarAnimation(this.scrollController, this.stepItems, {super.key});

  @override
  State<WizardBarAnimation> createState() => _WizardBarAnimationState();
}

class _WizardBarAnimationState extends State<WizardBarAnimation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, right: 12, left: 12),
      child: SizedBox(
        height: 46,
        child: Container(
          color: Colors.pink,
          child: Center(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: widget.scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.stepItems.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return widget.stepItems[index];
              },
            ),
          ),
        ),
      ),
    );
  }
}
