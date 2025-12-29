import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(context) {
    TextEditingController nombre = TextEditingController();
    TextEditingController correo = TextEditingController();
    TextEditingController clave = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Column(
        children: [
          TextField(
            controller: nombre,
            decoration: const InputDecoration(labelText: "Nombre"),
          ),
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
            onPressed: () =>
                validarRegistro(context, nombre, correo, clave),
            child: const Text("Registrar"),
          ),
        ],
      ),
    );
  }
}


Future<void> validarRegistro(
  context,
  TextEditingController nombre,
  TextEditingController correo,
  TextEditingController clave,
) async {
  if (nombre.text.isEmpty ||
      correo.text.isEmpty ||
      clave.text.isEmpty) {
    alertaRegistroError(context);
    return;
  }

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: correo.text,
      password: clave.text,
    );

    alertaRegistroOk(context);
    Navigator.pushNamed(context, "/login");
  } on FirebaseAuthException catch (e) {
    alertaRegistroFirebase(context, e.code);
  }
}


void alertaRegistroError(context) {
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

void alertaRegistroOk(context) {
  showDialog(
    context: context,
    builder: (context) {
      return const AlertDialog(
        title: Text("Registro"),
        content: Text("Registro exitoso"),
      );
    },
  );
}

void alertaRegistroFirebase(context, codigo) {
  String mensaje = "Error al registrar";

  if (codigo == "email-already-in-use") {
    mensaje = "El correo ya está registrado";
  } else if (codigo == "weak-password") {
    mensaje = "Contraseña muy débil";
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
