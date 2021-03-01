import 'package:finance_app/database/database.dart';
import 'package:finance_app/database/tables/table_account.dart';
import 'package:finance_app/model/account.dart';
import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  static String _radioValue = "Checking";
  static String _name;
  static String _nickname;
  static double _balance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text("Create New Account")
            ),
            body: Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Name: *",
                            hintText: "Enter a name for this account"
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a name for this account"; }
                          return null;
                        },
                        onSaved: (value) { _name = value; },
                      ),

                      _inputContainer(
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Nickname:",
                                hintText: "Enter a nickname for this account"
                            ),
                            onSaved: (value){ _nickname = value; },
                          )
                      ),

                      _inputContainer(
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Balance: *",
                                hintText: "Enter a starting balance",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a value for the starting balance"; }
                              else if (double.tryParse(value) == null) {
                                return "Please enter a valid number"; }
                              return null;
                            },
                            onSaved: (value){ _balance = double.tryParse(value); },
                          )
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text("Account Type",
                              style: TextStyle(
                                  fontSize: 14
                              )
                          ),
                        ),
                      ),

                      RadioListTile(
                        groupValue: _radioValue,
                        title: Text("Checking"),
                        value: "Checking",
                        onChanged: (value){
                          setState(() {
                            _radioValue = value;
                          });
                        },
                      ),

                      RadioListTile(
                        groupValue: _radioValue,
                        title: Text("Savings"),
                        value: "Savings",
                        onChanged: (value){
                          setState(() {
                            _radioValue = value;
                          });
                        },
                      ),

                      ElevatedButton(
                        child: Text("Submit"),
                        onPressed: () {
                          if(!_formKey.currentState.validate()){
                            return null; }

                          _formKey.currentState.save();

                          Account account = Account(
                            name: _name,
                            nickname: _nickname,
                            balance: _balance,
                            type: _radioValue
                          );

                          AccountTable().insertAccount(account).then((value) => Navigator.pop(context, account));
                        },
                      )
                    ],
                  )
              ),
            )
        )
    );
  }
}

Widget _inputContainer(Widget widget){
  return Container(
    margin: EdgeInsets.only(
      top: 10
    ),
    child: widget,
  );
}