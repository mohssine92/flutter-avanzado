import 'package:flutter/material.dart';

// paquete ...
import 'package:provider/provider.dart';
import 'package:seccion_6/helpers/mostrar_alerta.dart';

// Provider class
import 'package:seccion_6/services/auth_service.dart';

// widgets
import 'package:seccion_6/widgets/boton_azul.dart';
import 'package:seccion_6/widgets/custom_input.dart';
import 'package:seccion_6/widgets/labels.dart';
import 'package:seccion_6/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        // safeArea - widget de flutter - ayuda si algun dispositivos tienen noche como iphone
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              // obtener 90 por ciento de la pnatlla del dispositivo 55
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                // sepaar elemntos de la coleccion de child de column
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Logo(titulo: 'Messenger'),
                  _Form(),
                  const Labels(
                    ruta: 'register',
                    titulo: '¿No tienes cuenta?',
                    subTitulo: 'Crea una ahora!',
                  ),
                  const Text(
                    'Términos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  // Como estoy en statefulwidget pudeo implemenatar aqui  perfectamemte los controladores de los inputes
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Obtener provider class - listen : false - evitar que por defecto el provider redibuje el widget al dispara notifyListeners / - por defecto lister es true
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          // Input reutulizable
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),

          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),

          BotonAzul(
              text: 'Ingrese',
              // Ternario _bloquear button - evitar enviar dos peticiones en mismo tiempo
              onPressed: authService.autenticando
                  ? null
                  : () async {
                      /// quita el foco donde esta este - y quitar teclado si es necesario
                      FocusScope.of(context).unfocus();
                      final loginOk = await authService.login(
                          emailCtrl.text.trim(), passCtrl.text.trim());

                      if (loginOk) {
                        // TODO: Conectar a nuestro socket server

                        // Remplazar pantalla - No permire Retroceder
                        Navigator.pushReplacementNamed(context, 'usuarios');
                      } else {
                        mostrarAlerta(context, 'Login incorrecto',
                            'Revise sus credenciales nuevamente');
                      }
                    })
        ],
      ),
    );
  }
}
