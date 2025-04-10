import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'providers/transaction_provider.dart';

final ValueNotifier<bool> isDarkMode = ValueNotifier(false); // Dark mode toggle

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TransactionProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, darkModeEnabled, child) {
        return MaterialApp(
          title: 'My Finance Tracker',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: darkModeEnabled ? Brightness.dark : Brightness.light,
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/home') {
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
                settings: settings,
              );
            }
            return null;
          },
        );
      },
    );
  }
}
