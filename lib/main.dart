import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytask/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mytask/screens/task_page.dart';
import 'package:mytask/screens/welcome_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyTaskApp()));
}

class MyTaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyTask',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: AuthWrapper(),
    );
  }
}
class AuthWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return snapshot.data == null ? WelcomeScreen() : TaskPage();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}