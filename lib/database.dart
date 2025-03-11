import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'todo_item.dart';
import 'todo_dao.dart';

part 'database.g.dart'; // Generated code

@Database(version: 1, entities: [TodoItem])
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao;
}