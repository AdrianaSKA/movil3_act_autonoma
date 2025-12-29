import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(context) {
    TextEditingController correo = TextEditingController();
    TextEditingController clave = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          TextField(
            controller: correo,
            decoration: const InputDecoration(labelText: "Correo"),
          ),
          TextField(
            controller: clave,
            decoration: const InputDecoration(labelText: "Contraseña"),
            obscureText: true,
          ),
          FilledButton(
            onPressed: () => validarLogin(context, correo, clave),
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}

Future<void> validarLogin(
  context,
  TextEditingController correo,
  TextEditingController clave,
) async {
  if (correo.text.isEmpty || clave.text.isEmpty) {
    alertaCamposVacios(context);
    return;
  }

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: correo.text,
      password: clave.text,
    );

    alertaLoginCorrecto(context);

    Navigator.pushNamed(context, "/menu");
  } on FirebaseAuthException catch (e) {
    alertaErrorLogin(context, e.code);
  }
}


void alertaCamposVacios(context) {
  showDialog(
    context: context,
    builder: (context) {
      return const AlertDialog(
        title: Text("Error"),
        content: Text("Complete todos los campos"),
      );
    },
  );
}

void alertaLoginCorrecto(context) {
  showDialog(
    context: context,
    builder: (context) {
      return const AlertDialog(
        title: Text("Correcto"),
        content: Text("Login exitoso"),
      );
    },
  );
}

void alertaErrorLogin(context, codigo) {
  String mensaje = "Error de autenticación";

  if (codigo == "user-not-found") {
    mensaje = "Usuario no encontrado";
  } else if (codigo == "wrong-password") {
    mensaje = "Contraseña incorrecta";
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Error"),
        content: Text(mensaje),
      );
    },
  );
}
