import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:seccion_6/helpers/mostrar_alerta.dart';

import 'package:seccion_6/services/auth_service.dart';

import 'package:seccion_6/widgets/circl_login.dart';
import 'package:seccion_6/widgets/delivery_button_login.dart';
import 'package:seccion_6/widgets/delivery_input.dart';
import 'package:seccion_6/widgets/labels.dart';

class Register_d_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        // va occupar tada pantalla
        width: double.infinity,
        child: Stack(
          // widfet ecima de otros stack
          children: [
            Positioned(
              child: CirclLogin(),
              top: -80,
              left: -100,
            ),
            Positioned(
              child: _textRegister(),
              top: 65,
              left: 27,
            ),
            Positioned(
              child: _iconBack(),
              top: 51,
              left: -5,
            ),
            body(),
          ],
        ),
      ),
    )
        // appbar arriba y esto abajp
        );
  }

  Widget _textRegister() {
    return const Text(
      'Registro',
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: 'NimbusSans'),
    );
  }

  Widget _iconBack() {
    return IconButton(
        onPressed: () {},
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white));
  }
}

class body extends StatefulWidget {
  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> {
  final emailCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final apellidolCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final passCtrlConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 150),
      child: Column(
        children: [
          _imageUser(),
          const SizedBox(height: 30),
          DeliveryInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          DeliveryInput(
            icon: Icons.person,
            placeholder: 'Nombre',
            keyboardType: TextInputType.emailAddress,
            textController: nameCtrl,
          ),
          DeliveryInput(
            icon: Icons.person_outline,
            placeholder: 'Apellido',
            keyboardType: TextInputType.emailAddress,
            textController: apellidolCtrl,
          ),
          DeliveryInput(
            icon: Icons.phone,
            placeholder: 'Telefono',
            keyboardType: TextInputType.emailAddress,
            textController: telefonoCtrl,
          ),
          DeliveryInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),
          DeliveryInput(
            icon: Icons.lock_outline,
            placeholder: 'Confirmar Contraseña',
            textController: passCtrlConfirm,
            isPassword: true,
          ),
          DeliveryButtonLogin(
            text: 'Registrarse',
            onPressed: authService.autenticando
                ? () =>
                    {} // Simplemente no hace naga - si bloquear button (null)
                : () async {
                    print(nameCtrl.text);
                    print(emailCtrl.text);
                    print(passCtrl.text);
                    final registroOk = await authService.register(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passCtrl.text.trim());
                    // TODO: crear metofo similar aa register recibe arg para este form

                    if (registroOk == true) {
                      //  TODO: Conectar socket server
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      mostrarAlerta(context, 'Registro incorrecto', registroOk);
                    }
                  },
          ),
          const Labels(
            ruta: 'login',
            titulo: '¿Ya tienes una cuenta?',
            subTitulo: 'Ingresa ahora!',
          ),
          const SizedBox(height: 20),
          const Text(
            'Términos y condiciones de uso',
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _imageUser() {
    return CircleAvatar(
      backgroundImage: const AssetImage('assets/img/user_profile_2.png'),
      radius: 60,
      backgroundColor: Colors.grey[200],
    );
  }
}
