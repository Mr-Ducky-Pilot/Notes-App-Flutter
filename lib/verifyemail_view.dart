import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showErrorSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user!.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        backgroundColor: const Color.fromARGB(255, 123, 43, 169),
      ),
      body: Column(
        children: [
          Text("You are logged in as $email and your email isnt verified."),
          const Text('Please Verify your email id.'),
          TextButton(
            onPressed: () async {
              const message =
                  'Verification Mail Sent. Please check your email and verify';
              showErrorSnack(context, message);
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('Send Email Verification'),
          )
        ],
      ),
    );
  }
}
