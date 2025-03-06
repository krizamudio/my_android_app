import 'package:flutter/material.dart';
import 'package:my_android_app/db.dart';
import 'package:my_android_app/animal.dart';

class AnimalFormScreen extends StatefulWidget {
  final Animal? animal;
  final VoidCallback onSave;

  const AnimalFormScreen({super.key, this.animal, required this.onSave});

  @override
  _AnimalFormScreenState createState() => _AnimalFormScreenState();
}

class _AnimalFormScreenState extends State<AnimalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _id;
  late String _nombre;
  late String _especie;

  @override
  void initState() {
    super.initState();
    if (widget.animal != null) {
      _id = widget.animal!.id;
      _nombre = widget.animal!.nombre;
      _especie = widget.animal!.especie;
    } else {
      _id = 0;
      _nombre = '';
      _especie = '';
    }
  }

void _saveAnimal() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    Animal animal = Animal(id: _id, nombre: _nombre, especie: _especie);
    if (widget.animal == null) {
      await DB.insert(animal);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se ha insertado un nuevo registro')),
      );
    } else {
      await DB.update(animal);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se ha actualizado el registro')),
      );
    }
    widget.onSave();
    Navigator.pop(context);
  }
}

void _deleteAnimal() async {
  if (widget.animal != null) {
    await DB.delete(widget.animal!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Se ha eliminado el registro')),
    );
    widget.onSave();
    Navigator.pop(context);
  }
}

  

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.animal == null ? 'Nuevo Animal' : 'Editar Animal'),
      actions: widget.animal != null
          ? [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: _deleteAnimal,
              ),
            ]
          : null,
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: _id.toString(),
              decoration: InputDecoration(labelText: 'ID'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un ID';
                }
                return null;
              },
              onSaved: (value) {
                _id = int.parse(value!);
              },
            ),
            TextFormField(
              initialValue: _nombre,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
              onSaved: (value) {
                _nombre = value!;
              },
            ),
            TextFormField(
              initialValue: _especie,
              decoration: InputDecoration(labelText: 'Especie'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una especie';
                }
                return null;
              },
              onSaved: (value) {
                _especie = value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAnimal,
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    ),
  );
}}