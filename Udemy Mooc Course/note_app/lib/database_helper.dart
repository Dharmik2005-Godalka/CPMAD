import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'models/note_model.dart';

class DatabaseHelper 
{
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async 
  {
    if (_database != null) 
    {
      return _database!;
    }

    if (kIsWeb) 
    {
      _database = await databaseFactoryFfiWeb.openDatabase(
        'notes.db',
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE notes(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                content TEXT NOT NULL,
                createdAt TEXT NOT NULL
              )
            ''');
          },
        ),
      );
    } 
    else 
    {
      _database = await openDatabase(
        'notes.db',
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE notes(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              content TEXT NOT NULL,
              createdAt TEXT NOT NULL
            )
          ''');
        },
      );
    }

    return _database!;
  }

  Future<int> insertNote(Note note) async 
  {
    final db = await database;
    return db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async 
  {
    final db = await database;
    final maps = await db.query('notes', orderBy: 'id DESC');
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> updateNote(Note note) async 
  {
    final db = await database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async 
  {
    final db = await database;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
