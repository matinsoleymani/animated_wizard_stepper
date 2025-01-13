import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animated_wizard_bar/page_view/wizrdbar_viewmodel.dart';
import 'package:animated_wizard_bar/colors.dart';

/// Arguments required for creating a custom text field in the wizard bar.
class WizardTextFieldArguments {
  final bool? enableValidate; // Determines whether validation is enabled.
  final Key? keyTextField; // Key for the text field widget.
  final FocusNode focusNode; // Focus node for managing text field focus.
  final TextEditingController textEditingController; // Controller for text input.
  final String? label; // Label text for the text field.
  final String? typeInput; // Custom input type for validation.
  final int? maxLength; // Maximum character length of input.
  final Widget? icon; // Optional icon to display inside the text field.
  final TextDirection? textDirection; // Direction of the text input (LTR/RTL).
  final TextInputType? textInputType; // Keyboard type for the text field.
  final String? helperText; // Helper text displayed below the input.
  final bool enable; // Whether the text field is enabled or disabled.
  final int? maxLine; // Maximum number of lines in the text field.
  final String? regex; // Regular expression for input validation.
  final bool? hasMandatory; // Indicates whether the field is mandatory.
  final double? height; // Optional height of the widget.
  final Function() valueChanged; // Callback when the input value changes.
  final Function()? validator; // Callback when the validator is called.

  WizardTextFieldArguments({this.enableValidate, required this.keyTextField, required this.focusNode, required this.textEditingController, this.label, this.typeInput, this.maxLength, this.icon, this.textDirection, this.textInputType, this.helperText, required this.enable, this.maxLine, this.regex, this.hasMandatory, this.height, required this.valueChanged, this.validator});
}

/// A custom text field widget integrated with the wizard bar.
class WizardTextField extends StatefulWidget {
  final WizardTextFieldArguments args; // Input arguments for customization.

  const WizardTextField({super.key, required this.args});

  @override
  State<WizardTextField> createState() => _WizardTextFieldState();
}

class _WizardTextFieldState extends State<WizardTextField> {
  // Stores the last text value of the text field.
  String lastText = '';

  /// Determines whether validation is enabled.
  bool validateBoolean() {
    if (widget.args.enableValidate != null) {
      return widget.args.enableValidate == true;
    }
    return true;
  }

  Widget _mantadory() {
    if (widget.args.hasMandatory != null) {
      if (widget.args.hasMandatory == true) {
        return const Text("*", style: TextStyle(color: errorColor));
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Accessing the WizardBarViewModel for managing UI state.
    final wizardBarViewModel = Provider.of<WizardBarViewModel>(context, listen: true);

    return _buildContent(wizardBarViewModel: wizardBarViewModel);
  }

  /// Builds the main content of the text field widget.
  Widget _buildContent({required WizardBarViewModel wizardBarViewModel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Form(
        key: widget.args.keyTextField,
        child: TextFormField(
          autovalidateMode: validateBoolean() ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          onTap: () {
            // Store the current text when the field is tapped.
            lastText = widget.args.textEditingController.text;
          },
          onChanged: (value) {
            // Notify of value changes and adjust wizard bar size.
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
          style: TextStyle(color: widget.args.enable ? white : gray500),
          enabled: widget.args.enable,
          textDirection: widget.args.textDirection ?? TextDirection.ltr,
          keyboardType: widget.args.textInputType ?? TextInputType.text,
          controller: widget.args.textEditingController,
          textInputAction: TextInputAction.next,
          maxLength: widget.args.maxLength ?? 100,
          maxLines: widget.args.maxLine ?? 1,
          cursorColor: primaryColor,
          inputFormatters: [
            // Apply regex-based input filtering.
            FilteringTextInputFormatter.allow(RegExp(widget.args.regex ?? "."))
          ],
          validator: (valueValidator) {
            widget.args.validator ?? () {};
            return null;
            // You can uncomment and customize validation logic here.
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            isCollapsed: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: disableColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: gray400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: white),
            ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    widget.args.label ?? 'label',
                    style: const TextStyle(),
                  ),
                ),
                _mantadory()
                // widget.args.hasMandatory!=null?  const Text("*", style: TextStyle(color: errorColor)) : const SizedBox.shrink(),
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
            helperStyle: TextStyle(
              fontSize: MediaQuery.sizeOf(context).width >= 600 ? 12 : 10,
              color: textColor,
            ),
            counterText: "",
          ),
        ),
      ),
    );
  }
}
