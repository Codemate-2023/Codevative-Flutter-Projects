// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_signup_riverpod/providers.dart';
import 'package:login_signup_riverpod/signup.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(userServiceProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60.0,
              backgroundImage: NetworkImage(
                'https://i.pinimg.com/1200x/79/33/98/793398d63f16678a904b0c12f562f628.jpg',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              controller: emailController,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              controller: passwordController,
            ),
            const SizedBox(height: 40.0),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 5, 47, 109),
              ),
              onPressed: () async => await provider.login(
                emailController.text,
                passwordController.text,
              ),
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 35.0,
                      child: const Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 30.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SignUpPage(),
                  ),
                );
              },
              child: const SizedBox(
                height: 30.0,
                child: Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color.fromARGB(255, 5, 47, 109),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
