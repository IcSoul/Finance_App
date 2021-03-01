import 'dart:async';

import 'package:finance_app/model/account.dart';
import 'package:finance_app/model/transaction.dart';

import 'package:finance_app/database/tables/table_account.dart';
import 'package:finance_app/database/tables/table_transaction.dart';

enum AccountAction { Update }
enum TransactionAction { Update }

class ViewAccountBloc {
  int accountID;

  final _accountStateStreamController = StreamController<Account>.broadcast();
  StreamSink<Account> get _accountStateSink => _accountStateStreamController.sink;
  Stream<Account> get accountStateStream => _accountStateStreamController.stream;

  final _accountEventStreamController = StreamController<AccountAction>();
  StreamSink<AccountAction> get accountEventSink => _accountEventStreamController.sink;
  Stream<AccountAction> get _accountEventStream => _accountEventStreamController.stream;



  final _transactionStateStreamController = StreamController<List<Transaction>>();
  StreamSink<List<Transaction>> get _transactionStateSink => _transactionStateStreamController.sink;
  Stream<List<Transaction>> get transactionStateStream => _transactionStateStreamController.stream;

  final _transactionEventStreamController = StreamController<TransactionAction>();
  StreamSink<TransactionAction> get transactionEventSink => _transactionEventStreamController.sink;
  Stream<TransactionAction> get _transactionEventStream => _transactionEventStreamController.stream;



  ViewAccountBloc(int id) {
    this.accountID = id;

    _accountEventStream.listen((event) async {
      try {
        if(event == AccountAction.Update){
          Account account = await AccountTable().getAccount(accountID);
          _accountStateSink.add(account);
        }
      } on Exception catch (e) {
        _accountStateSink.addError("Failed to retrieve data.");
      }
    });

    _transactionEventStream.listen((event) async {
      try {
        if(event == TransactionAction.Update){
          List<Transaction> transactions = await TransactionTable().getTransactions(accountID);
          _transactionStateSink.add(transactions);
        }
      } on Exception catch (e) {
        _transactionStateSink.addError("Failed to retrieve data.");
      }
    });
  }

  void dispose() {
    _accountStateStreamController.close();
    _accountEventStreamController.close();

    _transactionStateStreamController.close();
    _transactionEventStreamController.close();
  }
}