import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'tables/table_account.dart';
import 'tables/table_transaction.dart';

class DatabaseProvider {
  DatabaseProvider();
  Database _database;

  Future<Database> get database async {
    if(_database != null){ return _database; }
    return await createDatabase();
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, "finance_database.db"),
      version : 1,
      onCreate: (Database database, int version) async {
        await database.execute(AccountTable().table);
        await database.execute(TransactionTable().table);
      }
    );
  }
}