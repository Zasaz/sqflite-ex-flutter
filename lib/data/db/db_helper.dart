import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_example_app/data/models/person_model.dart';

class DBHelper {
  final String dbName;
  Database _db;
  List<Person> _persons = [];
  static const String tableName = 'PEOPLE';
  final _streamController = StreamController<List<Person>>.broadcast();
  DBHelper(this.dbName);

  Future<List<Person>> _getAllPersons() async {
    final db = _db;
    if (db == null) {
      return [];
    }

    try {
      final read = await db.query(
        'PEOPLE',
        distinct: true,
        columns: [
          'ID',
          'FIRST_NAME',
          'LAST_NAME',
        ],
        orderBy: 'ID',
      );
      final people = read.map((e) => Person.fromRow(e)).toList();
      return people;
    } catch (e) {
      log('Error in catch: $e');
      return [];
    }
  }

  Future<bool> create(String firstName, String lastName) async {
    final db = _db;
    if (db == null) {
      return false;
    }

    try {
      final id = await db.insert(
        tableName,
        {
          'FIRST_NAME': firstName,
          'LAST_NAME': lastName,
        },
      );
      final person = Person(
        id: id,
        firstName: firstName,
        lastName: lastName,
      );
      _persons.add(person);
      _streamController.add(_persons);
      return true;
    } catch (e) {
      log('Error in catch: $e');
      return false;
    }
  }

  Future<bool> delete(Person person) async {
    final db = _db;
    if (db == null) {
      return false;
    }

    try {
      final deleteCount = await db.delete(
        tableName,
        where: 'ID = ?',
        whereArgs: [person.id],
      );
      if (deleteCount == 1) {
        _persons.remove(person);
        _streamController.add(_persons);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Error in catch: $e');
      return false;
    }
  }

  Future<bool> update(Person person) async {
    final db = _db;
    if (db == null) {
      return false;
    }

    try {
      final updateCount = await db.update(
        tableName,
        {
          'FIRST_NAME': person.firstName,
          'LAST_NAME': person.lastName,
        },
        where: 'ID = ?',
        whereArgs: [person.id],
      );
      if (updateCount == 1) {
        _persons.removeWhere((element) => element.id == person.id);
        _persons.add(person);
        _streamController.add(_persons);
        log('Updated: ${person.firstName}');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Error in catch: $e');
      return false;
    }
  }

  Future<bool> close() async {
    final db = _db;
    if (db == null) {
      return false;
    }

    await db.close();
    return true;
  }

  Future<bool> open() async {
    if (_db != null) {
      return true;
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$dbName';

    try {
      final db = await openDatabase(path);
      _db = db;

      const create =
          'CREATE TABLE IF NOT EXISTS $tableName (ID INTEGER PRIMARY KEY AUTOINCREMENT, FIRST_NAME TEXT, LAST_NAME TEXT)';

      await db.execute(create);

      // read all existing objects from db
      _persons = await _getAllPersons();
      _streamController.add(_persons);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error in catch: $e");
        return false;
      }
    }
  }

  Stream<List<Person>> exposeStream() =>
      _streamController.stream.map((persons) => persons..sort());
}
