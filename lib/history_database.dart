import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HistoryDatabase {
  
  Future<Database> openMyDatabase() async {
    

    return await openDatabase(
        
        join(await getDatabasesPath(), 'history1.db'),
        
        version: 1,
        
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE history(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, amount  INTEGER, month INTEGER, day INTEGER, hour INTEGER, minute INTEGER)',
      );
       
    });
  }

  Future<bool> historyHasData() async {
  final db = await openMyDatabase();
  final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(*) FROM history');
  final int count = result[0].values.first as int;
  return count > 0;
  }

  Future<void> insertHistory(int amount, int month, int day, int hour, int minute) async {
    final db = await openMyDatabase();
    
    db.insert(
        'history',
        {
          'amount': amount,
          'month': month,
          'day': day,
          'hour': hour,
          'minute': minute,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  clearhistory() async {
    final db = await openMyDatabase();
    
    return await db.rawDelete("DELETE FROM history");
  }

  Future<int?> getLastIndex() async{
    final db = await openMyDatabase();
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT MAX(id) FROM history');
    return result[0].values.first;
  }

  Future<List<Map<String,dynamic>>> getHistory() async {
    final db = await openMyDatabase();

    return await db.query('history');
  }
}