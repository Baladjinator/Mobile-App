import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:road_monitoring_app/constants.dart';
import 'package:road_monitoring_app/utils.dart';
import 'package:road_monitoring_app/widgets/email_form_field.dart';
import 'package:road_monitoring_app/widgets/form_text_button.dart';
import 'package:road_monitoring_app/widgets/password_form_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late String email;
  late String password;

  bool isObsecurePassword = true;
  bool isObsecureConfirmPassword = true;
  bool isloading = false;
  bool userIsValid = false;

  showSnackBar(String value) {
    final snackBar = SnackBar(
      content: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void registration() async {
    setState(() {
      isloading = true;
      userIsValid = false;
    });

    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          isloading = false;
        });

        showSnackBar('Registration succeed');
      } catch (e) {}

      setState(() {
        isloading = false;
      });

      if (userIsValid) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorLightTheme,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70.0.h,
              ),
              Container(
                //color: Colors.amber,
                child: Text(
                  'Register\nyour Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 34.0.sp,
                  ),
                ),
              ),
              SizedBox(height: 50.0.h),
              SizedBox(
                height: 310.0.h,
                child: Column(
                  children: [
                    EmailFormField(
                      controller: emailController,
                      validator: (value) {
                        if (!isValidEmail(value!)) {
                          return 'Please Enter a valid Email';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 16.0.h),
                    PasswordFormField(
                      controller: passwordController,
                      text: 'Password',
                      isObsecure: isObsecurePassword,
                      validator: (value) {
                        if (!isvalidPassword(value!)) {
                          return 'Enter a valid 8 Characters Password';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 16.0.h),
                    PasswordFormField(
                      controller: passwordController,
                      text: 'Confirm Password',
                      isObsecure: isObsecurePassword,
                      validator: (value) {
                        if (!isvalidPassword(value!)) {
                          return 'Passwords dont match';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.0.h),
              FormTextButton(
                text: 'Register',
                onPressed: registration,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
