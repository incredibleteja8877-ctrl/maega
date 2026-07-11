import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'providers/app_data_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth_gate.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  final appDataProvider = AppDataProvider();
  final themeProvider = ThemeProvider();
  await themeProvider.init();
  runApp(MaegaApp(appDataProvider: appDataProvider, themeProvider: themeProvider));
}

class MaegaApp extends StatelessWidget {
  final AppDataProvider appDataProvider;
  final ThemeProvider themeProvider;
  const MaegaApp({
    super.key,
    required this.appDataProvider,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appDataProvider),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Maega',
            themeMode: theme.themeMode,
            theme: ThemeData(
              primaryColor: kRed,
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(seedColor: kRed),
              textTheme: GoogleFonts.poppinsTextTheme(),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              primaryColor: kRed,
              scaffoldBackgroundColor: const Color(0xFF121212),
              colorScheme: ColorScheme.fromSeed(
                seedColor: kRed,
                brightness: Brightness.dark,
              ),
              textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
              useMaterial3: true,
            ),
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
