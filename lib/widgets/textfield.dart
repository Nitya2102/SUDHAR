import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.label,
    this.controller,
    this.isPassword = false,
    required this.hintStyle,
    required this.labelStyle,
    required this.inputStyle,
    //required this.fillColor,
  });

  final String hint;
  final String label;
  final bool isPassword;
  final TextEditingController? controller;
  final TextStyle hintStyle;
  final TextStyle labelStyle;
  final TextStyle inputStyle;
  //final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      style: inputStyle, // Set user input text style
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintStyle,
        labelText: label,
        labelStyle: labelStyle,
        filled: true, // Enable fill color
        //fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
        ),
      ),
    );
  }
}
