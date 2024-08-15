import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initDatabase() async {
  final directory = await getApplicationDocumentsDirectory();

  final path = "${directory.path}/expenses.db";
 
  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        '''
        CREATE TABLE expenses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          description TEXT,
          amount REAL,
          date TEXT
        )
        ''',
      );
      await db.execute(
        '''
        CREATE TABLE daily_totals(
          date TEXT PRIMARY KEY,
          total REAL
        )
        ''',
      );
    },
  );
}
