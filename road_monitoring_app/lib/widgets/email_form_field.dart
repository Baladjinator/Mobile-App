import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const EmailFormField({
    super.key,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0.r),
        ),
        prefixIcon: const Icon(Icons.email_rounded),
        hintText: 'Email',
        labelText: 'Email',
      ),
    );
  }
}
