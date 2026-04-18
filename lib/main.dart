import 'package:flutter/material.dart';
import 'package:multi_screen_app/screens/home_screen.dart';
import 'package:multi_screen_app/screens/login_screen.dart';
import 'package:multi_screen_app/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const baseSeed = Color(0xFF6D7BFF);
    return MaterialApp(
      title: 'Flutter Registration App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: baseSeed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF101935),
          foregroundColor: Color(0xFFF5F7FF),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF141D3A),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF131B34),
          labelStyle: const TextStyle(color: Color(0xFFC8D2FF)),
          prefixIconColor: const Color(0xFFAEBFFF),
          suffixIconColor: const Color(0xFFAEBFFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2A345F)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2A345F)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF7D8EFF), width: 1.5),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF101935),
          selectedItemColor: Color(0xFF9EABFF),
          unselectedItemColor: Color(0xFF7E89B4),
          type: BottomNavigationBarType.fixed,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7D8EFF),
            foregroundColor: const Color(0xFF090D1D),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: AuthService.currentUser != null
          ? HomeScreen(userName: AuthService.currentUser!.name)
          : const LoginScreen(),
    );
  }
}
