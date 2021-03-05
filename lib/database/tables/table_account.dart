import 'package:finance_app/model/account.dart';
import '../database.dart';

class AccountTable {
  static const String TABLE_NAME = "accounts";

  static const String COLUMN_ID = "id";
  static const String COLUMN_NICKNAME = "nickname";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_BALANCE = "balance";
  static const String COLUMN_TYPE = "type";

  static const String accountTable = "CREATE TABLE $TABLE_NAME("
    "$COLUMN_ID INTEGER PRIMARY KEY,"
    "$COLUMN_NAME TEXT,"
    "$COLUMN_NICKNAME TEXT,"
    "$COLUMN_BALANCE REAL,"
    "$COLUMN_TYPE TEXT)";

  String get table { return accountTable; }

  // Functions to get account data from the database;

  Future<List<Account>> getAccounts() async {
    final db = await DatabaseProvider().database;
    var accounts = await db.rawQuery("SELECT * FROM $TABLE_NAME");

    List<Account> accountList = <Account>[];
    accounts.forEach((item) {
      Account account = Account.fromMap(item);
      accountList.add(account);
    });

    return accountList;
  }

  Future<Account> getAccount(int id) async {
    final db = await DatabaseProvider().database;
    var account = await db.rawQuery("SELECT * FROM $TABLE_NAME WHERE $COLUMN_ID = $id");

    Account temp = Account.fromMap(account.asMap()[0]);
    return temp;
  }

  Future<Account> insertAccount(Account account) async {
    final db = await DatabaseProvider().database;
    account.id = await db.insert(TABLE_NAME, account.toMap());

    return account;
  }

  Future<Account> updateAccount(Account account) async {
    final db = await DatabaseProvider().database;
    await db.update(TABLE_NAME, account.toMap(), where: '$COLUMN_ID = ?', whereArgs: [account.id]);

    return account;
  }

  Future deleteAccount(int id) async {
    final db = await DatabaseProvider().database;
    await db.rawDelete("DELETE FROM $TABLE_NAME WHERE $COLUMN_ID = $id");

    return true;
  }
}
