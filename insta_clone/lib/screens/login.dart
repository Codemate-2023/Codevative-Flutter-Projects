// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/screens/feeds_screen.dart';
import 'package:insta_clone/screens/signup.dart';
import 'package:insta_clone/utils/colors.dart';

import '../resources/auth.dart';
import '../widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  bool _isLoginLoading = false;
  final passwordController = TextEditingController();

  showSnackBar(String content, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  void loginUser() async {
    setState(() {
      _isLoginLoading = true;
    });
    String response = await Auth().login(
      emailController.text,
      passwordController.text,
    );
    if (response != 'success') {
      showSnackBar(response, context);
    } else {
      showSnackBar(response, context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const FeedScreen()));
    }

    setState(() {
      _isLoginLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                colorFilter: const ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
                height: 64,
              ),
              const SizedBox(height: 42),
              TextFieldWidget(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                isPass: true,
                hintText: 'Enter your password',
                textInputType: TextInputType.visiblePassword,
                controller: passwordController,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => loginUser(),
                child: _isLoginLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: const ShapeDecoration(
                          color: blueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                        child: const Text('Log In'),
                      ),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account? "),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
