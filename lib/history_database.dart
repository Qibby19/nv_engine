import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HistoryDatabase {
  // all methods in this class are asynchronous because they involve I/O operations.
  Future<Database> openMyDatabase() async {

    return await openDatabase(
        // join method is used to join the path of the database with the path of the app's document directory.
        join(await getDatabasesPath(), 'history.db'),
        // The version of the database. This is used to manage database schema changes.
        version: 1,
        // onCreate is a callback function that is called ONLY when the database is created for the first time.
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE history(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, amount  INTEGER)',
      );
      //Here we are creating a table named todoList with three columns: id, title, and status.
      //The id column is the primary key and is set to autoincrement.    
      //We use INTEGER for the status column because SQLite does not have a boolean data type.
      //Instead, we use 0 for false and 1 for true.    
    });
  }

  Future<bool> historyHasData() async {
  final db = await openMyDatabase();
  final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(*) FROM history');
  final int count = result[0].values.first as int;
  return count > 0;
}

  Future<void> insertHistory(int amount) async {
    final db = await openMyDatabase();
    
    db.insert(
        'history',
        {
          'amount': amount,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  clearhistory() async {
    final db = await openMyDatabase();
    
    return await db.rawDelete("DELETE FROM history");
  }

  Future<List<Map<String,dynamic>>> getHistory() async {
    final db = await openMyDatabase();

    return await db.query('history');
  }
}