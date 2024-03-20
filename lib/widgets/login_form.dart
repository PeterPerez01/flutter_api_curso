import 'package:api_application/Api/authentication_api.dart';
import 'package:api_application/data/authentication_client.dart';
import 'package:api_application/pages/home_page.dart';
import 'package:api_application/utils/dialogs.dart';

import 'package:api_application/utils/responsive.dart';
import 'package:api_application/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  final _authenticationClient = GetIt.instance<AuthenticationClient>();
  final _authenticationAPI = GetIt.instance<AuthenticationAPI>();
  String _email = '';
  String _password = '';
  Future<void> _submit() async {
    final isOk = _formkey.currentState!.validate();
    if (isOk) {
      ProgressDialog.show(context);

      final response = await _authenticationAPI.login(
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
          message = 'Error de conexión';
        } else if (response.error!.statusCode == 403) {
          message = "Contraseña incorrecta";
        } else if (response.error!.statusCode == 404) {
          message = "No se encontró el usuario";
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
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black12,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InputText(
                        label: 'Contraseña',
                        obscureText: true,
                        borderEnabled: false,
                        fontSize:
                            responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                        onChanged: (text) {
                          _password = text;
                        },
                        validator: (text) {
                          if (text!.trim().isEmpty||text.length<6) {
                            return 'Contraseña inválida';
                          }
                          return null;
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Olvidaste?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: responsive.dp(5),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.blueAccent,
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(
                      'Iniciar sesión',
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
                    '¿Aún no tienes una cuenta?',
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
                          'register',
                        );
                      },
                      child: Text(
                        'Registro',
                        style: TextStyle(
                          fontSize:
                              responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: responsive.dp(10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
