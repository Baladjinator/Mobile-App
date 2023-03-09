import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String text;
  bool isObsecure;

  PasswordFormField({
    super.key,
    required this.controller,
    required this.validator,
    required this.text,
    required this.isObsecure,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: super.widget.validator,
      obscureText: super.widget.isObsecure,
      controller: super.widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0.r),
        ),
        prefixIcon: const Icon(Icons.lock_rounded),
        suffixIcon: GestureDetector(
          child: Icon(
            super.widget.isObsecure
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
          ),
          onTap: () {
            setState(() {
              super.widget.isObsecure = !super.widget.isObsecure;
            });
          },
        ),
        hintText: super.widget.text,
        labelText: super.widget.text,
      ),
    );
  }
}
