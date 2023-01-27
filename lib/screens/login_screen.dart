// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:project_devscore/responsive/mobile_screen_layout.dart';
import 'package:project_devscore/responsive/responsive_layout.dart';
import 'package:project_devscore/responsive/web_screen_layout.dart';
import 'package:project_devscore/screens/signup_screen.dart';
import 'package:project_devscore/services/auth_methods.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:project_devscore/utils/global_variables.dart';
import 'package:project_devscore/widgets/policy_text.dart';
import 'package:project_devscore/widgets/snackbar.dart';
import 'package:project_devscore/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    // it's important to dispose these controllers  after this widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logInUser() async {
    setState(() {
      _isLoading = true;
    });
    String result = await AuthMethods().LoginUser(
        email: _emailController.text, password: _passwordController.text);

    if (result == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: ((context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )),
        ),
      );
    } else {
      showSnackBar(context, result.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              Text(
                'DevsCore',
                style: TextStyle(
                    color: blueColor,
                    fontSize: 70.0,
                    fontFamily: 'Festive',
                    fontWeight: FontWeight.w500),
              ),
              TextFieldInput(
                  hintText: 'Enter your email',
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress),
              SizedBox(
                height: 24.0,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                textEditingController: _passwordController,
                textInputType: TextInputType.visiblePassword,
                isPass: true,
              ),
              SizedBox(
                height: 25.0,
              ),
              InkWell(
                onTap: logInUser,
                child: Container(
                  child: _isLoading
                      ? Center(
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Log in',
                          style: TextStyle(
                            fontFamily: 'pacifico',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              SizedBox(
                height: 6.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      "Don't have an account ?",
                      style: TextStyle(color: Colors.black),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ));
                    },
                    child: Container(
                      child: const Text(
                        "  Sign up.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: blueColor),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              policyText(),
            ],
          ),
        ),
      ),
    );
  }
}
