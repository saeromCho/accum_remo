import 'package:flutter/material.dart';

class CompleteMemoTextButton extends StatelessWidget {
  const CompleteMemoTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
      },
      child: const Text(
        '완료',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
