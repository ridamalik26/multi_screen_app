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
    return MaterialApp(
      title: 'Flutter Registration App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F4F8),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: AuthService.currentUser != null
          ? HomeScreen(userName: AuthService.currentUser!.name)
          : const LoginScreen(),
    );
  }
}
