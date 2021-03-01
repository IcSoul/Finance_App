import 'package:finance_app/database/tables/table_account.dart';

class Account {
  int id;
  String name;
  String nickname;
  double balance;
  String type;

  Account({this.id, this.name, this.nickname, this.balance, this.type});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      AccountTable.COLUMN_NAME : name,
      AccountTable.COLUMN_NICKNAME : nickname,
      AccountTable.COLUMN_BALANCE : balance,
      AccountTable.COLUMN_TYPE : type
    };

    if(id != null){
      map[AccountTable.COLUMN_ID] = id;
    }

    return map;
  }

  Account.fromMap(Map<String, dynamic> map){
    id = map[AccountTable.COLUMN_ID];
    name = map[AccountTable.COLUMN_NAME];
    nickname = map[AccountTable.COLUMN_NICKNAME];
    balance = map[AccountTable.COLUMN_BALANCE];
    type = map[AccountTable.COLUMN_TYPE];
  }
}