import 'package:api_application/data/authentication_client.dart';
import 'package:api_application/pages/home_page.dart';
import 'package:api_application/pages/login_page.dart';
import 'package:api_application/utils/logs.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _authenticationClient = GetIt.instance<AuthenticationClient>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  Future<void> _checkLogin() async {
    final token = await _authenticationClient.accessToken;
    Logs.p.i(token);
    if (token == null) {
      Navigator.pushReplacementNamed(
        context,
        LoginPage.routeName,
      );
      return;
    }
    Navigator.pushReplacementNamed(
      context,
      HomePage.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
