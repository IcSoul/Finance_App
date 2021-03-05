import 'package:finance_app/model/transaction.dart';
import '../database.dart';

class TransactionTable {
  static const String TABLE_NAME = "transactions";

  static const String COLUMN_ID = "id";
  static const String COLUMN_DATE = "date";
  static const String COLUMN_AMOUNT = "amount";
  static const String COLUMN_DESC = "description";
  static const String COLUMN_TYPE = "type";
  static const String COLUMN_ACCOUNT = "account";

  static const String transactionTable = "CREATE TABLE $TABLE_NAME("
    "$COLUMN_ID INTEGER PRIMARY KEY,"
    "$COLUMN_DATE TEXT,"
    "$COLUMN_AMOUNT REAL,"
    "$COLUMN_DESC TEXT,"
    "$COLUMN_TYPE TEXT,"
    "$COLUMN_ACCOUNT Integer)";

  String get table { return transactionTable; }

  // Functions to get transaction data from the database;

  Future<List<Transaction>> getTransactions(int id) async {
    final db = await DatabaseProvider().database;
    var transactions = await db.rawQuery("SELECT * FROM $TABLE_NAME WHERE $COLUMN_ACCOUNT = $id");

    List<Transaction> transactionList = <Transaction>[];
    transactions.forEach((item){
      Transaction transaction = Transaction.fromMap(item);
      transactionList.add(transaction);
    });

    return transactionList;
  }

  Future<Transaction> getTransaction(int id) async {
    final db = await DatabaseProvider().database;
    var transaction = await db.rawQuery("SELECT * FROM $TABLE_NAME WHERE $COLUMN_ID = $id");

    Transaction temp = Transaction.fromMap(transaction.asMap()[0]);
    return temp;
  }

  Future<Transaction> insertTransaction(Transaction transaction) async {
    final db = await DatabaseProvider().database;
    transaction.id = await db.insert(TABLE_NAME, transaction.toMap());

    return transaction;
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    final db = await DatabaseProvider().database;
    await db.update(TABLE_NAME, transaction.toMap(), where: '$COLUMN_ID = ?', whereArgs: [transaction.id]);

    return transaction;
  }

  Future deleteTransactions(int id) async {
    final db = await DatabaseProvider().database;
    await db.rawDelete("DELETE FROM $TABLE_NAME WHERE $COLUMN_ACCOUNT = $id");

    return true;
  }

  Future deleteTransaction(int id) async {
    final db = await DatabaseProvider().database;
    await db.rawDelete("DELETE FROM $TABLE_NAME WHERE $COLUMN_ID = $id");

    return true;
  }
}