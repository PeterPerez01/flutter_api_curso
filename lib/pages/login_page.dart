import 'package:api_application/utils/responsive.dart';
import 'package:api_application/widgets/circle.dart';
import 'package:api_application/widgets/icon_container.dart';
import 'package:api_application/widgets/login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double pinkSize = responsive.wp(80);
    final double orangeSize = responsive.hp(57);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: responsive.height,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -pinkSize * 0.4,
                  right: -pinkSize * 0.2,
                  child: Circle(
                    size: pinkSize,
                    colors: const [
                      Colors.blueGrey,
                      Colors.blue,
                    ],
                  ),
                ),
                Positioned(
                  top: -orangeSize * 0.55,
                  left: -orangeSize * 0.15,
                  child: Circle(
                    size: orangeSize,
                    colors: const [
                      Colors.blue,
                      Color.fromARGB(255, 48, 89, 160),
                    ],
                  ),
                ),
                Positioned(
                  top: pinkSize * 0.35,
                  child: Column(
                    children: [
                      IconContainer(
                        size: responsive.wp(17),
                      ),
                      SizedBox(
                        height: responsive.dp(3),
                      ),
                      Text(
                        'Bienvenido de Nuevo\nInicia sesión',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: responsive.dp(1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
