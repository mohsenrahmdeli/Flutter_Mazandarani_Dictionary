import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

Future<Database> _initDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'words.db');

  if (!await File(path).exists()) {
    final data = await rootBundle.load('assets/alldata.db');
    final bytes = data.buffer.asUint8List();
    await File(path).writeAsBytes(bytes);
  }

  return await openDatabase(path);
}

  Future<List<WordModel>> searchWords(String query) async {
    final db = await database;
    final result = await db.query(
      'words',
      where: 'word LIKE ?',
      whereArgs: ['$query%'],
    );

    return result.map((map) => WordModel.fromMap(map)).toList();
  }
}
