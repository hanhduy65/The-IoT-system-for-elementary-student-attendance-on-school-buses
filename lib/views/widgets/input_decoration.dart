import 'package:flutter/material.dart';

class BoxedInputDecoration extends InputDecoration {
  final String? displayLabelText;
  final String? displayHintText;
  final Widget? displayPrefixIcon;
  final Widget? displaySuffixIcon;
  final Widget? ss;
  final Widget? customPrefixWidget;
  final Widget? customSuffixWidget;
  final String? helper;
  final String? prefixString;
  final Color? filledColor;

  const BoxedInputDecoration(
      {this.displayLabelText,
      this.displayHintText,
      this.prefixString,
      this.ss,
      this.displayPrefixIcon,
      this.displaySuffixIcon,
      this.customPrefixWidget,
      this.customSuffixWidget,
      this.helper,
      this.filledColor});

  @override
  // TODO: implement labelText
  String? get labelText => displayLabelText;

  @override
  // TODO: implement hintText
  String? get hintText => displayHintText;

  @override
  // TODO: implement enabledBorder
  InputBorder? get enabledBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFFF4FAFF)),
      );

  @override
  // TODO: implement focusedBorder
  InputBorder? get focusedBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFF93EF7B)),
      );

  @override
  // TODO: implement errorBorder
  InputBorder? get errorBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.red),
      );

  @override
  // TODO: implement focusedErrorBorder
  InputBorder? get focusedErrorBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.red),
      );

  @override
  // TODO: implement contentPadding
  EdgeInsetsGeometry? get contentPadding => const EdgeInsets.all(8);

  @override
  // TODO: implement prefix
  Widget? get prefix => customPrefixWidget;

  @override
  // TODO: implement suffix
  Widget? get suffix => customSuffixWidget;

  @override
  // TODO: implement prefixIcon
  Widget? get prefixIcon => displayPrefixIcon;

  @override
  // TODO: implement suffixIcon
  Widget? get suffixIcon => displaySuffixIcon ?? ss;

  @override
  // TODO: implement helperText
  String? get helperText => helper;

  @override
  // TODO: implement fillColor
  Color? get fillColor => filledColor;

  @override
  // TODO: implement filled
  bool? get filled => true;

  @override
  // TODO: implement prefixText
  String? get prefixText => prefixString;
}
