import 'package:sqflite/sqflite.dart';
import 'package:my_android_app/animal.dart';
import 'package:path/path.dart';

class DB {

  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'animales.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE animales(id INTEGER PRIMARY KEY, nombre TEXT, especie TEXT)"
        );
      },
      version: 1,
    );
  }
  
  static Future<void> insert(Animal animal) async {
    Database database = await _openDB();
    await database.insert("animales", animal.toMap());
  }

  static Future<void> delete(Animal animal) async{
    Database database = await _openDB();
    await database.delete("animales", where: "id = ?", whereArgs: [animal.id]);
  }

  static Future<void> update(Animal animal) async{
    Database database = await _openDB();
    await  database.update("animales", animal.toMap(), where: "id = ?", whereArgs: [animal.id]);
  }

  static Future<List<Animal>> getAnimales() async {
    Database database = await _openDB();
    List<Map<String, dynamic>> animales = await database.query("animales");
    return List.generate(animales.length, (index) {
      return Animal(
        id: animales[index]['id'],
        nombre: animales[index]['nombre'],
        especie: animales[index]['especie']
      );
    });
  }

  //CONS SENTENCIAS SQL
  static Future<void> insertaSQL(Animal animal) async{
    Database database = await _openDB();
    var res = await database.rawInsert("INSERT INTO animales (id, nombre, especie)"
    "VALUES (${animal.id}, ${animal.nombre},${animal.especie})");
  }
}