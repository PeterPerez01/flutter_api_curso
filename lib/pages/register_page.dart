import 'package:api_application/utils/responsive.dart';
import 'package:api_application/widgets/avatar_button.dart';
import 'package:api_application/widgets/circle.dart';
import 'package:api_application/widgets/register_form.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = 'register';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double pinkSize = responsive.wp(88);
    final double orangeSize = responsive.hp(35);
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
                  top: -pinkSize * 0.3,
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
                  top: -orangeSize * 0.45,
                  left: -orangeSize * 0.15,
                  child: Circle(
                    size: orangeSize,
                    colors: const [
                      Colors.blue,
                      Color.fromARGB(255, 28, 55, 102),
                    ],
                  ),
                ),
                Positioned(
                  top: pinkSize * 0.17,
                  child: Column(
                    children: [
                      Text(
                        'Bienvenido\nCrea tu cuenta',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: responsive.dp(1.5),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: responsive.dp(5.5),
                      ),
                      AvatarButton(
                        imageSize: responsive.wp(25),
                      ),
                    ],
                  ),
                ),
                const RegisterForm(),
                Positioned(
                  left: 15,
                  top: 15,
                  child: SafeArea(
                    child: CupertinoButton(
                      color: Colors.black26,
                      padding: const EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(30),
                      child: const Icon(
                        Icons.arrow_back_ios,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
