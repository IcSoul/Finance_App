import 'package:finance_app/database/tables/table_transaction.dart';

class Transaction {
  int id;
  String date;
  double amount;
  String description;
  String type;
  int account;

  Transaction({this.id, this.date, this.amount, this.description, this.type, this.account});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      TransactionTable.COLUMN_DATE : date,
      TransactionTable.COLUMN_AMOUNT : amount,
      TransactionTable.COLUMN_DESC : description,
      TransactionTable.COLUMN_TYPE : type,
      TransactionTable.COLUMN_ACCOUNT : account
    };

    if(id != null){
      map[TransactionTable.COLUMN_ID] = id;
    }

    return map;
  }

  Transaction.fromMap(Map<String, dynamic> map){
    id = map[TransactionTable.COLUMN_ID];
    date = map[TransactionTable.COLUMN_DATE];
    amount = map[TransactionTable.COLUMN_AMOUNT];
    description = map[TransactionTable.COLUMN_DESC];
    type = map[TransactionTable.COLUMN_TYPE];
    account = map[TransactionTable.COLUMN_ACCOUNT];
  }
}