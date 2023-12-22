// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  TextFormFieldWidget(
      {super.key,
      required this.prefixIcon,
      required this.label,
      required this.controller,
      required this.validator,
      this.keyboardType,
      this.suffixIcon,
      this.onpressSufix,
      this.obscureText = false});
  final Widget? prefixIcon;
  final Widget? label;
  final IconData? suffixIcon;
  bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  void Function()? onpressSufix;
  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 3,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon:
                IconButton(icon: Icon(suffixIcon), onPressed: onpressSufix),
            label: label,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}
