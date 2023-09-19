// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_signup_riverpod/providers.dart';

class SignUpPage extends ConsumerWidget {
  SignUpPage({super.key});

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(userServiceProvider);
    return Scaffold(
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
                labelText: 'Username',
              ),
              controller: usernameController,
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
              onPressed: () async {
                await provider.signup(
                  emailController.text,
                  passwordController.text,
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 35.0,
                child: provider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
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
