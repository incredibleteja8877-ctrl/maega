import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

/// Root auth router — shows [LoginScreen] when signed out, or [HomeScreen]
/// (after loading the signed-in user's Firestore data) when signed in.
/// Also makes the app auto-resume into [HomeScreen] on relaunch if a
/// session is already active.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _loadedUid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          _loadedUid = null;
          return const LoginScreen();
        }

        if (_loadedUid != user.uid) {
          _loadedUid = user.uid;
          context.read<AppDataProvider>().loadForUser(user.uid);
        }

        return const HomeScreen();
      },
    );
  }
}
