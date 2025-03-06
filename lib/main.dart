import 'package:flutter/material.dart';
import 'package:my_android_app/animal_form_screen.dart';
import 'package:my_android_app/db.dart';
import 'package:my_android_app/animal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimalListScreen(),
    );
  }
}

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  _AnimalListScreenState createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  late Future<List<Animal>> _animalList;

  @override
  void initState() {
    super.initState();
    _refreshAnimalList();
  }

  void _refreshAnimalList() {
    setState(() {
      _animalList = DB.getAnimales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Animales'),
      ),
      body: FutureBuilder<List<Animal>>(
        future: _animalList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay animales.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Animal animal = snapshot.data![index];
                return ListTile(
                  title: Text(animal.nombre),
                  subtitle: Text(animal.especie),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnimalFormScreen(
                                animal: animal,
                                onSave: _refreshAnimalList,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await DB.delete(animal);
                          _refreshAnimalList();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnimalFormScreen(
                onSave: _refreshAnimalList,
              ),
            ),
          );
        },
      ),
    );
  }
}