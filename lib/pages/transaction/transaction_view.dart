import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:finance_app/model/transaction.dart';
import 'package:finance_app/model/account.dart';

import 'package:finance_app/controller/controller_transaction.dart';

import 'package:finance_app/database/tables/table_transaction.dart';
import 'package:finance_app/database/tables/table_account.dart';

import 'package:finance_app/shared/widgets.dart';

class ViewTransactionPage extends StatefulWidget {
  final int id;

  ViewTransactionPage({Key key, @required this.id}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ViewTransactionPage> {
  final TransactionBloc _transactionBloc = TransactionBloc();
  bool _showEdit = false;

  @override
  void initState() {
    _transactionBloc.singleEventSink.add(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    _transactionBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: StreamBuilder<Transaction>(
          stream: _transactionBloc.singleStateStream,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Column(
                children: [
                  _transactionHeader(snapshot.data),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => {
                          setState(() {
                            _showEdit = true;
                          })
                        },
                        child: Icon(Icons.edit),
                      ),

                      SizedBox(width: 10),

                      GestureDetector(
                        onTap: () => _deleteTransactionDialog(context, snapshot.data),
                        child: Icon(Icons.delete),
                      )
                    ],
                  ),

                  _showEdit ? _editTransactionForm(snapshot.data) : Container()
                ],
              );
            }

            return Center(
              child: Container(
                width: 50,
                height: 50,

                child: CircularProgressIndicator()
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _transactionHeader(Transaction transaction) {
  return Container(
    padding: EdgeInsets.only(bottom: 40),
    child: Row(
      children: [
        Expanded(
          flex: 10,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        transaction.date,
                        style: TextStyle(
                          fontSize: 20
                        )
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        transaction.amount.toString(),
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        transaction.type,
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ),
                  )
                ],
              ),

              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  transaction.description,
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Future _deleteTransactionDialog(BuildContext context, Transaction transaction) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text("Delete Transaction"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text("Are you sure you want to delete this transaction?"),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "*The account associated with this transaction will have it's balance updated!",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12
                  ),
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Confirm"),
            onPressed: () async {
              Account account = await AccountTable().getAccount(transaction.account);
              account.balance = transaction.type.toLowerCase() == "debit"
                ? account.balance + transaction.amount : account.balance - transaction.amount;

              await AccountTable().updateAccount(account);
              await TransactionTable().deleteTransaction(transaction.id);

              TransactionTable().deleteTransaction(transaction.id)
                .then((value) => AccountTable().updateAccount(account)
                .then((value) => {
                  Navigator.of(context).pop(),
                  Get.back()
                }));
            },
          ),

          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }
  );
}

Widget _editTransactionForm(Transaction transaction) {
  final _formKey = GlobalKey<FormState>();

  String _date = transaction.date;
  double _amount = transaction.amount;
  String _description = transaction.description;

  return Container(
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Date: *",
              hintText: "Enter a date for this transaction",
            ),
            initialValue: _date,
            validator: (value) {
              try {
                if(!GetUtils.isDateTime(DateTime.parse(value).toString())){
                  return "Please enter a valid date for this transaction"; }
                return null;
              } on Exception catch (e) {
                return "Please enter a valid date for this transaction";
              }
            },
            onSaved: (value) { _date = value; },
          ),

          formTextFieldContainer(
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Amount: *",
                hintText: "Enter an amount for this transaction"
              ),
              initialValue: _amount.toString(),
              validator: (value) {
                if(!GetUtils.isCurrency(value)){
                  return "Please enter a valid amount"; }
                return null;
              },
              onSaved: (value) { _amount = double.tryParse(value); },
            )
          ),

          formTextFieldContainer(
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Description:",
                hintText: "Enter a description for this transaction"
              ),
              initialValue: _description,
              onSaved: (value) { _description = value; },
            )
          ),

          ElevatedButton(
            child: Text("Submit"),
            onPressed: () async {
              if(!_formKey.currentState.validate()){
                return null; }

              _formKey.currentState.save();

              Account account = await AccountTable().getAccount(transaction.account);
              account.balance = transaction.type.toLowerCase() == "debit"
                ? account.balance + transaction.amount - _amount
                : account.balance - transaction.amount + _amount;

              transaction.date = _date;
              transaction.amount = _amount;
              transaction.description = _description;

              TransactionTable().updateTransaction(transaction)
                .then((value) => AccountTable().updateAccount(account)
                .then((value) => Get.back()));
            },
          )
        ],
      )
    ),
  );
}