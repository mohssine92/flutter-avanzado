import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// paquete ...
import 'package:provider/provider.dart';
import 'package:seccion_6/helpers/mostrar_alerta.dart';

// Provider class
import 'package:seccion_6/services/auth_service.dart';
import 'package:seccion_6/services/socket_service.dart';
import 'package:seccion_6/utils/my_colors.dart';

// widgets
import 'package:seccion_6/widgets/boton_azul.dart';
import 'package:seccion_6/widgets/circl_login.dart';
import 'package:seccion_6/widgets/custom_input.dart';
import 'package:seccion_6/widgets/labels.dart';
import 'package:seccion_6/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.loginCaground, //const Color(0xffF2F2F2),
        // safeArea - widget de flutter - ayuda si algun dispositivos tienen noche como iphone
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(children: [
              Positioned(
                child: CirclLogin(),
                top: -80,
                left: -100,
              ),
              Positioned(
                child: _textLogin(),
                top: 60,
                left: 25,
              ),

              Container(
                // obtener 90 por ciento de la pnatlla del dispositivo 55
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  // sepaar elemntos de la coleccion de child de column
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Logo(
                    //     top: 100,
                    //     titulo: 'Delivery Maroc',
                    //     path: 'assets/img/delivery.png'),
                    _lottieAnimation(context),

                    _Form(),
                    const Labels(
                      // ruta: 'register',  // opcion fernando herrera
                      ruta: 'register_delivery', // opcion delivery
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

              // Container(
              //   margin: EdgeInsets.only(top: 60, left: 60),
              //   child: Text('LOGIN'),
              // ),
            ]),
          ),
        ));
  }

  Widget _textLogin() {
    return const Text('Login',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'NimbusSans'));
  }

  Widget _lottieAnimation(context) {
    return Container(
      margin: const EdgeInsets.only(top: 150),
      child: Lottie.asset('assets/json/delivery.json',
          width: 350, height: 200, fit: BoxFit.fill),
    );
  }
}

// NB : no quiero coneccion de socket en page login - porque todavia no hay usuario logueado asi no se quien es usuario socket

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
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          // Input reutulizable
          CustomInput(
            //icon: Icons.mail_outline,
            icon: Icons.email,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),

          CustomInput(
            // icon: Icons.lock_outline,
            icon: Icons.lock,
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
                        // en provider class socketService no occupo constructor - occupo funcion publica : asi controlo en que punto exacto connecto socket
                        // obviamnete despues de loguear - Objetivo  tener token de autenticacion del storage en breve
                        socketService.connect();
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
