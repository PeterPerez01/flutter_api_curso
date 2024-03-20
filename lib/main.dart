import 'package:api_application/helpers/dependency_injection.dart';
import 'package:api_application/pages/home_page.dart';
import 'package:api_application/pages/login_page.dart';
import 'package:api_application/pages/register_page.dart';
import 'package:api_application/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  DependencyInjection.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'API Curso',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashPage(),
      routes: {
        RegisterPage.routeName: (_) => const RegisterPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        HomePage.routeName: (_) => const HomePage(),
      },
    );
  }
}
