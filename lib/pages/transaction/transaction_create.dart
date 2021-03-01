import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:finance_app/pages/shared.dart';

import 'package:finance_app/model/account.dart';
import 'package:finance_app/model/transaction.dart';

import 'package:finance_app/database/tables/table_transaction.dart';
import 'package:finance_app/database/tables/table_account.dart';

class CreateTransactionPage extends StatefulWidget {
  final int id;

  CreateTransactionPage({Key key, @required this.id}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<CreateTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  static String _radioValue = "Debit";
  static String _date;
  static double _amount;
  static String _description;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Create New Transaction"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Date: *",
                    hintText: "Enter a date for this transaction"
                  ),
                  validator: (value) {
                    if(value.isEmpty) {
                      return "Please enter a date for this transaction"; }
                    return null;
                  },
                  onSaved: (value) { _date = value; }
                ),

                formTextFieldContainer(
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Amount: *",
                      hintText: "Enter an amount for this transaction"
                    ),
                    validator: (value) {
                      if(value.isEmpty){
                        return "Please enter a value for the amount"; }
                      else if(double.tryParse(value) == null){
                        return "Please enter a valid number"; }
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
                    onSaved: (value) { _description = value; },
                  )
                ),

                formRadioFieldHeader("Transaction Type"),

                RadioListTile(
                  groupValue: _radioValue,
                  title: Text("Debit"),
                  value: "Debit",
                  onChanged: (value){
                    setState(() {
                      _radioValue = value;
                    });
                  },
                ),

                RadioListTile(
                  groupValue: _radioValue,
                  title: Text("Credit"),
                  value: "Credit",
                  onChanged: (value){
                    setState(() {
                      _radioValue = value;
                    });
                  },
                ),

                ElevatedButton(
                  child: Text("Submit"),
                  onPressed: () async {
                    if(!_formKey.currentState.validate()){
                      return null; }

                    _formKey.currentState.save();

                    Transaction transaction = Transaction(
                      date: _date,
                      amount: _amount,
                      description: _description,
                      type: _radioValue,
                      account: widget.id
                    );

                    /*
                    * Figure out a better way to write this
                    * */

                    Account account = await AccountTable().getAccount(widget.id);
                    account.balance = transaction.type.toLowerCase() == "debit"
                      ? account.balance - transaction.amount : account.balance + transaction.amount;

                    TransactionTable().insertTransaction(transaction)
                      .then((value) => AccountTable().updateAccount(account)
                      .then((value) => Navigator.pop(context)));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}