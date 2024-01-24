import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// To show error codes to the user lets use SnackBars!! Look at optional stuff you can do with SnackBars!!
void showErrorSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: "Enter your email here",
          ),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(
            hintText: "Enter yout password",
          ),
        ),
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            try {
              // final userCredential = await FirebaseAuth.instance
              //     .signInWithEmailAndPassword(
              //         email: email, password: password);
              await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);
              String message = "Duck Logged in Successfully!";
              showErrorSnack(context, message);
              // print(userCredential);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                String message = "Duck Doesn't Exist! Please Register instead";
                showErrorSnack(context, message);
              } else if (e.code == 'wrong-password') {
                String message =
                    "Quack Quack, you have entered a wrong password!";
                showErrorSnack(context, message);
              } else {
                String message =
                    "Quack Quack, something went wrong. See the error below.${e.code}";
                showErrorSnack(context, message);
              }
            }
          },
          child: const Text("Login as a Duck"),
        ),
        TextButton(
          onPressed: () {},
          child: const Text("Not Registered Yet? Register Here!"),
        )
      ],
    );
  }
}
