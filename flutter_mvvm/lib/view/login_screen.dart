import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mvvm/resources/components/round_button.dart';
import 'package:flutter_mvvm/utils/routes/utils.dart';
import 'package:flutter_mvvm/view_model/auth_view_model.dart';
// import 'package:flutter_mvvm/view/home_screen.dart';
import 'package:provider/provider.dart';

import '../utils/routes/routes_name.dart';
// import '../utils/routes/routes_name.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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
            title: 'Login',
            loading: authViewModel.loading,
            onPress: () {
              if (email.text.isEmpty) {
                Utils.flushBarMessage('Please enter email!', context);
              } else if (password.text.isEmpty) {
                Utils.flushBarMessage('Please enter password!', context);
              } else if (password.text.length < 6) {
                Utils.flushBarMessage(
                    'Password should be at least 6 digits!', context);
              } else {
                Map data = {
                  'email': email.text.toString(),
                  'password': password.text.toString(),
                };
                authViewModel.loginApi(data, context);
                log('api hit!');
              }
            },
          ),
          SizedBox(height: height * .02),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutesName.signup);
            },
            child: const Text("Don't have an account? Sign Up."),
          ),
        ],
      ),
    );
  }
}
