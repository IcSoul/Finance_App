import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:finance_app/pages/shared.dart';
import 'package:get/get.dart';

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
          automaticallyImplyLeading: false,
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
                    try {
                      if(!GetUtils.isDateTime(DateTime.parse(value).toString())){
                        return "Please enter a valid date for this transaction"; }
                      return null;
                    } on Exception catch (e) {
                      return "Please enter a valid date for this transaction";
                    }
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

                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text("Cancel"),
                        onPressed: () => Get.back(),
                      ),

                      SizedBox(width: 30),

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}