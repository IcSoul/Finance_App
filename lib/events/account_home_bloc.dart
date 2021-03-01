import 'dart:async';

import 'package:finance_app/database/tables/table_account.dart';
import 'package:finance_app/model/account.dart';

enum AccountAction { Update }

class AccountHomeBloc {
  final _stateStreamController = StreamController<List<Account>>();
  StreamSink<List<Account>> get _stateSink => _stateStreamController.sink;
  Stream<List<Account>> get stateStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<AccountAction>();
  StreamSink<AccountAction> get eventSink => _eventStreamController.sink;
  Stream<AccountAction> get _eventStream => _eventStreamController.stream;

  AccountHomeBloc() {
    _eventStream.listen((event) async {
      try {
        if(event == AccountAction.Update){
          List<Account> accounts = await AccountTable().getAccounts();
          _stateSink.add(accounts);
        }
      } on Exception catch (e) {
        _stateSink.addError("Failed to retrieve data.");
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}