import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mvvm/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';

import '../resources/components/round_button.dart';
import '../utils/routes/utils.dart';
import '../view_model/auth_view_model.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    _obscurePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 1;
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              focusNode: emailNode,
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.alternate_email,
                ),
              ),
              onFieldSubmitted: (value) {
                Utils.fieldFocusChange(
                  context,
                  emailNode,
                  passwordNode,
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _obscurePassword,
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: password,
                  focusNode: passwordNode,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscurePassword.value,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        _obscurePassword.value = !_obscurePassword.value;
                      },
                      child: Icon(
                        _obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    Utils.fieldFocusChange(
                      context,
                      passwordNode,
                      emailNode,
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(height: height * .1),
          RoundButton(
            title: 'Sign Up',
            loading: authViewModel.loading,
            onPress: () {
              if (email.text.isEmpty) {
                Utils.flushBarMessage('Please enter email!', context);
              } else if (password.text.isEmpty) {
                Utils.flushBarMessage('Please enter password!', context);
              } else if (password.text.length < 6) {
                Utils.flushBarMessage(
                    'Password should be at least 6 digits!', context);
                // Utils.snackBar(
                //     'Password should be at least 6 digits!', context);
              } else {
                Map data = {
                  'email': email.text.toString(),
                  'password': password.text.toString(),
                };
                authViewModel.signupApi(data, context);
                log('api hit!');
              }
            },
          ),
          SizedBox(height: height * .02),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutesName.login);
            },
            child: const Text("already have an account? Log in."),
          ),
        ],
      ),
    );
  }
}
