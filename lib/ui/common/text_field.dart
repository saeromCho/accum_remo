import 'package:flutter/material.dart';
import 'package:local_db_sqlite/utils/ui_constant.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.textController,
      this.isObscureText = false})
      : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController textController;
  final bool isObscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 14),
        labelStyle: TextStyle(color: primaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(width: 1, color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(width: 1, color: primaryColor),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      controller: textController,
      obscureText: isObscureText,
    );
  }
}
