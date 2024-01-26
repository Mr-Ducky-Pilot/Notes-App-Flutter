import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/verifyemail_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Duck Registration',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 160, 33, 33)),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/notesview': (context) => const NotesView(),
      },
    ),
  );
}

////Previous Class which had a scaffold to display the current logged in user.
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Welcome to Duck's Home!"),
//       ),
//       body: FutureBuilder(
//         future: Firebase.initializeApp(
//           options: DefaultFirebaseOptions.currentPlatform,
//         ),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               final user = FirebaseAuth.instance.currentUser;
//               // if (user!.isAnonymous == false) {
//               //   // if (user?.emailVerified ?? false) {
//               //   if (user.emailVerified == true) {
//               //     //print("You have a verified Email yaayyyy!!");
//               //     // final userstatus = user.emailVerified;
//               //     String status = 'verified';
//               //     // if (userstatus == true) {
//               //     //   status = 'Verified';
//               //     // } else {
//               //     //   status = 'unverified';
//               //     // }
//               //     final userName = user.email;
//               //     return Text(
//               //         "You are logged in as $userName your email verification status is : $status");
//               //   } else {
//               //     // print("Please verify your Duck ID...");
//               //     return const VerifyEmailView();
//               //   }
//               // }
//               return LoginView();
//             default:
//               return const Text("Connecting to Duck Server...");
//           }
//         },
//       ),
//     );
//   }
// }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout, viewProfile }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        backgroundColor: const Color.fromARGB(255, 123, 43, 169),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login/',
                      (_) => false,
                    );
                  }
                case MenuAction.viewProfile:
                // TODO: Handle this case.
                //Write a view to show the user profile with some basic info later on
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: MenuAction.viewProfile,
                  child: Text('View Profile'),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log Out'),
                ),
              ];
            },
          )
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to Log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log Out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
