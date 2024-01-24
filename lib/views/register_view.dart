import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

// To show error codes to the user lets use SnackBars!! Look at optional stuff you can do with SnackBars!!
void showErrorSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duck Registration'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
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
                        //     .createUserWithEmailAndPassword(
                        //         email: email, password: password);
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password);
                        String message = "Duck Registered Sucessfully!!";
                        showErrorSnack(context, message);
                        // print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          String message =
                              "Quack!! Weak Password Detected! Unacepetable!";
                          showErrorSnack(context, message);
                        } else if (e.code == 'email-already-in-use') {
                          String message =
                              "You Dumb Duck! Email is already in use. Try Login Instead!";
                          showErrorSnack(context, message);
                        } else if (e.code == 'invalid-email') {
                          String message =
                              "Quack! Invalid Email you dummy! Please Enter a valid email!";
                          showErrorSnack(context, message);
                        } else {
                          String message =
                              "Quack Quack... Something went wrong... see the error code below." +
                                  e.code;
                          showErrorSnack(context, message);
                        }
                      }
                    },
                    child: const Text("Register as a Duck"),
                  ),
                ],
              );
            default:
              return const Text('Loading App....');
          }
        },
      ),
    );
  }
}
