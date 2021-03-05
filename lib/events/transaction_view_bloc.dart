import 'dart:async';

import 'package:finance_app/database/tables/table_transaction.dart';
import 'package:finance_app/model/transaction.dart';

enum TransactionAction { Get, Update }

class ViewTransactionBloc {
  int transactionID;

  final _stateStreamController = StreamController<Transaction>.broadcast();
  StreamSink<Transaction> get _stateSink => _stateStreamController.sink;
  Stream<Transaction> get stateStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<TransactionAction>();
  StreamSink<TransactionAction> get eventSink => _eventStreamController.sink;
  Stream<TransactionAction> get _eventStream => _eventStreamController.stream;

  ViewTransactionBloc(int transaction){
    this.transactionID = transaction;

    _eventStream.listen((event) {
      try {
        if(event == TransactionAction.Update){

        }
      } on Exception catch(e) {
        _stateSink.addError("Failed to retrieve data.");
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}