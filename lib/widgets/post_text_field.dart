import 'package:flutter/material.dart';

class PostTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  const PostTextField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      maxLines: null,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 178, 210, 226)),
            gapPadding: (8),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
