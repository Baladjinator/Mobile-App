import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:road_monitoring_app/main.dart';
import 'package:road_monitoring_app/utils/utils.dart';
import 'package:road_monitoring_app/widgets/email_form_field.dart';
import 'package:road_monitoring_app/widgets/form_text_button.dart';
import 'package:road_monitoring_app/widgets/password_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isObsecure = true;
  bool isloading = false;
  bool userIsValid = false;

  void showSnackBar() {
    const snackBar = SnackBar(
      content: Text(
        'User not Found',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void login() async {
    setState(() {
      isloading = true;
      userIsValid = false;
    });

    if (formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;

      int responseCode = await restService.attemptLogIn(email, password);
      print(responseCode);

      if (responseCode == 202) {
        setState(() {
          print("a");
          userIsValid = true;
        });
      } else {
        setState(() {
          userIsValid = false;
          showSnackBar();
        });
      }

      setState(() {
        isloading = false;
      });

      if (userIsValid) {
        Navigator.pushReplacementNamed(context, '/home_page');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/icons/logo.png',
                height: 175.0.h,
              ),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Login to\nyour Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 34.0.sp,
                      ),
                    ),
                    SizedBox(height: 50.0.h),
                    SizedBox(
                      height: 210.0.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            isObsecure: isObsecure,
                            validator: (value) {
                              if (!isvalidPassword(value!)) {
                                return 'Enter a valid 8 Characters Password';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  FormTextButton(
                    text: 'Log In',
                    onPressed: login,
                  ),
                  SizedBox(height: 15.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New user?',
                        style: TextStyle(
                          fontSize: 15.0.sp,
                        ),
                      ),
                      SizedBox(
                        width: 5.0.w,
                      ),
                      InkWell(
                        splashColor: null,
                        onTap: () {
                          Navigator.pushNamed(context, '/registration_page');
                          emailController.clear();
                          emailController.text = '';
                          passwordController.clear();
                          passwordController.text = '';
                          formKey.currentState!.reset();
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: const Color(0xFF10cf6f),
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
