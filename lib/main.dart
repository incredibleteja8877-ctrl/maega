import 'package:flutter/material.dart';
import 'constants.dart';
import 'data/app_data.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppData();
  runApp(const MaegaApp());
}

class MaegaApp extends StatelessWidget {
  const MaegaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maega',
      theme: ThemeData(
        primaryColor: kRed,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: kRed),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
