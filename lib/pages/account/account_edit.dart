import 'package:flutter/material.dart';

import 'package:finance_app/model/account.dart';
import 'package:finance_app/database/tables/table_account.dart';
import 'package:finance_app/pages/shared.dart';
import 'package:get/get.dart';

class EditAccountPage extends StatefulWidget {
  final Account account;

  EditAccountPage({Key key, @required this.account}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<EditAccountPage> {
  final _formKey = GlobalKey<FormState>();

  static String _name;
  static String _nickname;

  @override
  void initState() {
    _name = widget.account.name;
    _nickname = widget.account.nickname;

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            title: Text("Edit Account"),
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
                      labelText: "Name: *",
                      hintText: "Enter a name for this account"
                  ),
                  initialValue: _name,
                  validator: (value) {
                    if(value.isEmpty){
                      return "Please enter a name for this account"; }
                    return null;
                  },
                  onSaved: (value) { _name = value; },
                ),

                formTextFieldContainer(
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Nickname:",
                          hintText: "Enter a nickname for this account"
                      ),
                      initialValue: _nickname,
                      onSaved: (value) { _nickname = value; },
                    )
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
                        onPressed: () {
                          if(!_formKey.currentState.validate()){
                            return null; }

                          _formKey.currentState.save();

                          Account account = widget.account;
                          account.name = _name;
                          account.nickname = _nickname;

                          AccountTable().updateAccount(account).then((value) => Get.back());
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}