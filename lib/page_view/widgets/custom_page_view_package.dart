import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_wizard_bar/colors.dart';
import 'package:animated_wizard_bar/page_view/custom_page_viewmodel.dart';
import 'package:animated_wizard_bar/page_view/widgets/step_horizontal_animation.dart';
import 'package:animated_wizard_bar/page_view/widgets/wizardbar_animation.dart';

class CustomPageView extends StatefulWidget {
  final List<AnimationController> aniController;
  final ScrollController singleChildScrollController;
  final List<StepHorizontalAnimation> stepsList;
  final WizardBarAnimation wizardBarAnimation;
  final Container? containerTopOfPage;
  final Widget? firstButton;
  final Widget? secondButton;
  final PreferredSizeWidget appBar;
  final List<Widget> pageViewItems;

  const CustomPageView({super.key, required this.appBar, required this.pageViewItems, required this.aniController, required this.singleChildScrollController, required this.wizardBarAnimation, this.containerTopOfPage, this.firstButton, this.secondButton, required this.stepsList});

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final customPageViewModel = Provider.of<CustomPageViewModel>(context);
    return Scaffold(
        appBar: widget.appBar,
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            wizardBar(),
            pages(customPageViewModel),
            bottomButtons(customPageViewModel, context, () {}),
          ],
        ));
  }

  Container wizardBar() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          widget.wizardBarAnimation,
        ],
      ),
    );
  }

  Positioned pages(CustomPageViewModel customPageViewModel) {
    return Positioned.fill(
      top: 72,
      bottom: 62,
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.pageViewItems.length,
        itemBuilder: (context, index) {
          return widget.pageViewItems[index];
        },
        padEnds: true,
        scrollDirection: Axis.horizontal,
        controller: customPageViewModel.pageViewController,
      ),
    );
  }

  Positioned bottomButtons(CustomPageViewModel customPageViewModel, BuildContext context, Function onPress) {
    return Positioned(
        height: 64,
        bottom: 0,
        right: 0,
        left: 0,
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: gray400.withOpacity(0.4),
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ],
            color: white,
          ),
          child: Row(
            mainAxisAlignment: customPageViewModel.currentLevel == 5 ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.secondButton ??
                  InkWell(
                    onTap: () {
                      customPageViewModel.previousPage(widget.aniController, widget.singleChildScrollController, widget.stepsList.length, widget.stepsList[customPageViewModel.currentLevel].boxKey);
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.sizeOf(context).width * 0.35,
                      decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: Colors.black, width: 1), borderRadius: BorderRadius.circular(24)),
                      child: const Center(child: Text('back')),
                    ),
                  ),
              customPageViewModel.currentLevel == 5
                  ? const SizedBox()
                  : widget.firstButton ??
                      InkWell(
                        onTap: () {
                          customPageViewModel.nextPage(widget.aniController, widget.singleChildScrollController, widget.stepsList.length, widget.stepsList[customPageViewModel.currentLevel].boxKey, context);
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.sizeOf(context).width * 0.35,
                          decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(24)),
                          child: const Center(
                              child: Text(
                            'next',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
            ],
          ),
        ));
  }
}
