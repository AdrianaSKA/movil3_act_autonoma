import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class NotasScreen extends StatelessWidget {
  const NotasScreen({super.key});

  @override
  Widget build(context) {
    TextEditingController titulo = TextEditingController();
    TextEditingController descripcion = TextEditingController();
    TextEditingController precio = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: titulo,
          decoration: const InputDecoration(labelText: "Título"),
        ),
        TextField(
          controller: descripcion,
          decoration: const InputDecoration(labelText: "Descripción"),
        ),
        TextField(
          controller: precio,
          decoration: const InputDecoration(labelText: "Precio"),
          keyboardType: TextInputType.number,
        ),
        FilledButton(
          onPressed: () =>
              guardarNota(titulo.text, descripcion.text, precio.text),
          child: const Text("Guardar Gasto"),
        ),
        const Expanded(child: ListaNotas()),
      ],
    );
  }
}

Future<void> guardarNota(titulo, descripcion, precio) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  DatabaseReference ref =
      FirebaseDatabase.instance.ref("gastos/$uid").push();

  await ref.set({
    "titulo": titulo,
    "descripcion": descripcion,
    "precio": precio,
  });
}



class ListaNotas extends StatelessWidget {
  const ListaNotas({super.key});

  @override
  Widget build(context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("gastos/$uid");

    return StreamBuilder(
      stream: ref.onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.data!.snapshot.value == null) {
          return const Text("No hay gastos registrados");
        }

        Map data = snapshot.data!.snapshot.value as Map;
        List notas = [];

        data.forEach((key, value) {
          notas.add({
            "id": key,
            "titulo": value["titulo"],
            "descripcion": value["descripcion"],
            "precio": value["precio"],
          });
        });

        return ListView.builder(
          itemCount: notas.length,
          itemBuilder: (context, index) {
            final item = notas[index];

            return Card(
              child: ListTile(
                title: Text(item["titulo"]),
                subtitle: Text(item["descripcion"]),
                trailing: Text("\$${item["precio"]}"),
                leading: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => eliminarNota(item["id"]),
                ),
                onTap: () => editarNota(context, item),
              ),
            );
          },
        );
      },
    );
  }
}


Future<void> eliminarNota(id) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference ref =
      FirebaseDatabase.instance.ref("gastos/$uid/$id");

  await ref.remove();
}


void editarNota(context, item) {
  TextEditingController titulo =
      TextEditingController(text: item["titulo"]);
  TextEditingController descripcion =
      TextEditingController(text: item["descripcion"]);
  TextEditingController precio =
      TextEditingController(text: item["precio"]);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Editar Gasto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titulo),
            TextField(controller: descripcion),
            TextField(controller: precio),
            FilledButton(
              onPressed: () {
                actualizarNota(
                  item["id"],
                  titulo.text,
                  descripcion.text,
                  precio.text,
                );
                Navigator.pop(context);
              },
              child: const Text("Actualizar"),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> actualizarNota(id, titulo, descripcion, precio) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference ref =
      FirebaseDatabase.instance.ref("gastos/$uid/$id");

  await ref.update({
    "titulo": titulo,
    "descripcion": descripcion,
    "precio": precio,
  });
}
