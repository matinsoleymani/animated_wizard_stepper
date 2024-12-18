import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animated_wizard_bar/page_view/wizrdbar_viewmodel.dart';
import 'package:animated_wizard_bar/colors.dart';

class CustomTextFieldWizardBarArguments {
  final bool? enableValidate;
  final Key? keyTextField;
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final String label;
  final String typeInput;
  final int maxLength;
  final Widget? icon;
  final TextDirection textDirection;
  final TextInputType textInputType;
  final String? helperText;
  final bool enable;
  final int maxLine;
  final String? regex;
  final bool mandatory;
  final double? height;
  final Function() valueChanged;

  CustomTextFieldWizardBarArguments({
    this.enableValidate,
    required this.keyTextField,
    required this.focusNode,
    required this.textEditingController,
    required this.label,
    required this.typeInput,
    required this.maxLength,
    this.icon,
    required this.textDirection,
    required this.textInputType,
    this.helperText,
    required this.enable,
    required this.maxLine,
    this.regex,
    required this.mandatory,
    this.height,
    required this.valueChanged,
  });
}

class CustomTextFieldWizardBar extends StatefulWidget {
  final CustomTextFieldWizardBarArguments args;
  const CustomTextFieldWizardBar({super.key, required this.args});

  @override
  State<CustomTextFieldWizardBar> createState() => _CustomTextFieldWizardBarState();
}

class _CustomTextFieldWizardBarState extends State<CustomTextFieldWizardBar> {
  bool validateBoolean() {
    if (widget.args.enableValidate != null) {
      if (widget.args.enableValidate == true) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  String lastText = '';

  @override
  Widget build(BuildContext context) {
    final wizardBarViewModel = Provider.of<WizardBarViewModel>(context, listen: true);

    return _buildContent(
      wizardBarViewModel: wizardBarViewModel,
    );
  }

  Widget _buildContent({
    required WizardBarViewModel wizardBarViewModel,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Form(
        key: widget.args.keyTextField,
        child: TextFormField(
          autovalidateMode: validateBoolean() == true ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          onTap: () {
            lastText = widget.args.textEditingController.text;
          },
          onChanged: (value) {
            widget.args.valueChanged();
            if (lastText.isEmpty && value.isNotEmpty) {
              wizardBarViewModel.increaseContainerSize();
            } else if (lastText.isNotEmpty && value.isEmpty) {
              wizardBarViewModel.decreaseContainerSize();
            }
            setState(() {
              lastText = value;
            });
          },
          focusNode: widget.args.focusNode,
          style: TextStyle(
            color: widget.args.enable ? white : gray500,
          ),
          enabled: widget.args.enable,
          textDirection: widget.args.textDirection,
          keyboardType: widget.args.textInputType,
          controller: widget.args.textEditingController,
          textInputAction: TextInputAction.next,
          maxLength: widget.args.maxLength,
          maxLines: widget.args.maxLine,
          cursorColor: primaryColor,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(widget.args.regex ?? "."))
          ],
          validator: (valueValidator) {
            // if (valueValidator!.isEmpty) {
            //   return '${widget.args.label} $notBeEmpty';
            // }
            // if (widget.args.typeInput == "idNum") {
            //   if (!valueValidator.isIranianNationalId) {
            //     return '${widget.args.label} $isWrong';
            //   }
            // }
            // if (widget.args.typeInput == "phoneNumber") {
            //   // if (!valueValidator.isPhoneNumber) {
            //   //   return '$label $isWrong';
            //   // }
            //   if (valueValidator.length < 11) {
            //     return '${widget.args.label} $isWrong';
            //   }
            // }

            // if (widget.args.typeInput == "telephone") {
            //   if (valueValidator.length < 11) {
            //     return '${widget.args.label} $isWrong';
            //   }
            // }

            // if (widget.args.typeInput == "insurance") {
            //   if (valueValidator.isNotEmpty) {
            //     if (valueValidator.length < 10) {
            //       return '${widget.args.label} $isWrong';
            //     }
            //   }
            // }

            // if (widget.args.typeInput == "postalCode") {
            //   if (!valueValidator.isValidIranianPostalCode()) {
            //     return '${widget.args.label} $isWrong';
            //   }
            // }
            // if (widget.args.typeInput == "email") {
            //   if (!EmailValidator.validate(valueValidator)) {
            //     return '${widget.args.label} $isWrong';
            //   }
            // } else {
            //   return null;
            // }
            // return null;
          },
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              isCollapsed: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: disableColor),
              ),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: gray400)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: white)),
              // labelText: label,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      widget.args.label,
                      style: const TextStyle(),
                    ),
                  ),
                  widget.args.mandatory
                      ? const Text(
                          "*",
                          style: TextStyle(
                            color: errorColor,
                          ),
                        )
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                ],
              ),
              labelStyle: TextStyle(
                color: widget.args.focusNode.hasFocus
                    ? white
                    : widget.args.enable
                        ? gray400
                        : gray400,
              ),
              alignLabelWithHint: true,
              prefixIcon: widget.args.icon,
              prefixIconColor: widget.args.focusNode.hasFocus
                  ? white
                  : widget.args.enable
                      ? gray400
                      : gray400,
              helperMaxLines: 2,
              helperText: widget.args.helperText,
              helperStyle: TextStyle(fontSize: MediaQuery.sizeOf(context).width >= 600 ? 12 : 10, color: textColor),
              counterText: ""),
        ),
      ),
    );
  }
}
