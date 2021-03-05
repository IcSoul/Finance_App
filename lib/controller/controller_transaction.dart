import 'dart:async';

import 'package:finance_app/database/tables/table_transaction.dart';
import 'package:finance_app/model/transaction.dart';

class TransactionBloc {
  // CONTROLLER TO RETURN A SINGLE TRANSACTION OBJECT
  final _singleStreamController = StreamController<Transaction>.broadcast();
  StreamSink<Transaction> get _singleStateSink => _singleStreamController.sink;
  Stream<Transaction> get singleStateStream => _singleStreamController.stream;

  final _singleEventStreamController = StreamController<int>();
  StreamSink<int> get singleEventSink => _singleEventStreamController.sink;
  Stream<int> get _singleEventStream => _singleEventStreamController.stream;


  // CONTROLLER TO RETURN A LIST OF TRANSACTIONS
  final _listStreamController = StreamController<List<Transaction>>.broadcast();
  StreamSink<List<Transaction>> get _listStateSink => _listStreamController.sink;
  Stream<List<Transaction>> get listStateStream => _listStreamController.stream;

  final _listEventStreamController = StreamController<int>();
  StreamSink<int> get listEventSink => _listEventStreamController.sink;
  Stream<int> get _listEventStream => _listEventStreamController.stream;

  TransactionBloc() {
    _singleEventStream.listen((int id) async {
      try {
        Transaction transaction = await TransactionTable().getTransaction(id);
        _singleStateSink.add(transaction);
      } on Exception catch (e) {
        _singleStateSink.addError("Failed to retrieve data.");
      }
    });

    _listEventStream.listen((int id) async {
      try {
        List<Transaction> transactions = await TransactionTable().getTransactions(id);
        _listStateSink.add(transactions);
      } on Exception catch (e) {
        _listStateSink.addError("Failed to retrieve data.");
      }
    });
  }

  void dispose() {
    _singleStreamController.close();
    _singleEventStreamController.close();

    _listStreamController.close();
    _listEventStreamController.close();
  }
}