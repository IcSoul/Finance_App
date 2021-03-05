import 'dart:async';

import 'package:finance_app/database/tables/table_account.dart';
import 'package:finance_app/model/account.dart';

enum EventType { Get }

class AccountBloc {
  //CONTROLLER TO RETURN A SINGLE ACCOUNT OBJECT
  final _singleStreamController = StreamController<Account>.broadcast();
  StreamSink<Account> get _singleStateSink => _singleStreamController.sink;
  Stream<Account> get singleStateStream => _singleStreamController.stream;

  final _singleEventStreamController = StreamController<int>();
  StreamSink<int> get singleEventSink => _singleEventStreamController.sink;
  Stream<int> get _singleEventStream => _singleEventStreamController.stream;


  // CONTROLLER TO RETURN A LIST OF ACCOUNTS
  final _listStreamController = StreamController<List<Account>>.broadcast();
  StreamSink<List<Account>> get _listStateSink => _listStreamController.sink;
  Stream<List<Account>> get listStateStream => _listStreamController.stream;

  final _listEventStreamController = StreamController<EventType>();
  StreamSink<EventType> get listEventSink => _listEventStreamController.sink;
  Stream<EventType> get _listEventStream => _listEventStreamController.stream;

  AccountBloc() {
    _singleEventStream.listen((int id) async {
      try {
        Account account = await AccountTable().getAccount(id);
        _singleStateSink.add(account);
      } on Exception catch (e) {
        _singleStateSink.addError("Failed to retrieve data.");
      }
    });

    _listEventStream.listen((event) async {
      try {
        List<Account> accounts = await AccountTable().getAccounts();
        _listStateSink.add(accounts);
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