import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:road_monitoring_app/themes/constants.dart';
import 'package:road_monitoring_app/main.dart';
import 'package:road_monitoring_app/utils/utils.dart';
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
      String email = emailController.text;
      String password = passwordController.text;

      int responseCode = await restService.attemptSignUp(email, password);

      if (responseCode == 201) {
        setState(() {
          userIsValid = true;
        });
      } else {
        setState(() {
          userIsValid = false;
          showSnackBar('User with Email Already exists');
        });
      }

      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorDarkTheme,
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
              Text(
                'Register\nyour Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 34.0.sp,
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
                      controller: confirmPasswordController,
                      text: 'Confirm Password',
                      isObsecure: isObsecurePassword,
                      validator: (value) {
                        if (passwordController.text !=
                            confirmPasswordController.text) {
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
                onPressed: () {
                  registration();
                  if (userIsValid) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
