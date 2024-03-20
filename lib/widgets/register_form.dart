import 'dart:convert';

import 'package:api_application/Api/authentication_api.dart';
import 'package:api_application/data/authentication_client.dart';
import 'package:api_application/pages/home_page.dart';
import 'package:api_application/pages/login_page.dart';

import 'package:api_application/utils/dialogs.dart';
import 'package:api_application/utils/responsive.dart';
import 'package:api_application/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  final _authenticationClient = GetIt.instance<AuthenticationClient>();
  final _authenticationAPI = GetIt.instance<AuthenticationAPI>();
  String _email = '';
  String _password = '';
  String _username = '';

  Future<void> _submit() async {
    final isOk = _formkey.currentState!.validate();
    if (isOk) {
      ProgressDialog.show(context);

      final response = await _authenticationAPI.register(
        username: _username,
        email: _email,
        password: _password,
      );
      ProgressDialog.dissmiss(context);
      if (response.data != null) {
        await _authenticationClient.saveSession(response.data!);

        Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.routeName,
          (_) => false,
        );
      } else {
        String message = response.error!.message;
        if (response.error!.statusCode == -1) {
          message = 'Error de Conexión';
        } else if (response.error!.statusCode == 409) {
          message =
              'Usuario duplicado ${jsonEncode(response.error!.data['duplicatedFields'])}';
        }

        Dialogs.alert(
          context,
          title: 'Error',
          description: message,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Positioned(
      bottom: 30,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: responsive.isTablet ? 430 : 330,
        ),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              InputText(
                keyboardType: TextInputType.emailAddress,
                label: 'Nombre de usuario',
                fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                onChanged: (text) {
                  _username = text;
                },
                validator: (text) {
                  if (text!.trim().length < 5) {
                    return 'Nombre de usuario inválido';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: responsive.dp(1),
              ),
              InputText(
                keyboardType: TextInputType.emailAddress,
                label: 'Correo electrónico',
                fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                onChanged: (text) {
                  _email = text;
                },
                validator: (text) {
                  if (!text!.contains('@')) {
                    return 'Correo inválido';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: responsive.dp(1),
              ),
              InputText(
                keyboardType: TextInputType.emailAddress,
                label: 'Contraseña',
                obscureText: true,
                fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                onChanged: (text) {
                  _password = text;
                },
                validator: (text) {
                  if (text!.trim().length < 6) {
                    return 'Contraseña inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.blueAccent,
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(
                      'Registro',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: responsive.dp(2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes una cuenta?',
                    style: TextStyle(
                      fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          LoginPage.routeName,
                        );
                      },
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize:
                              responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: responsive.dp(5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
