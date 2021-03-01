import 'dart:async';

import 'package:flutter/material.dart';

import 'package:finance_app/model/transaction.dart';
import 'package:finance_app/model/account.dart';
import 'package:finance_app/pages/transaction/transaction_create.dart';
import 'package:finance_app/events/account_view_bloc.dart';

class ViewAccountPage extends StatefulWidget {
  final int id;

  ViewAccountPage({Key key, @required this.id}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ViewAccountPage> {
  ViewAccountBloc stateBloc;

  @override
  void initState(){
    stateBloc = ViewAccountBloc(widget.id);
    stateBloc.accountEventSink.add(AccountAction.Update);
    stateBloc.transactionEventSink.add(TransactionAction.Update);

    super.initState();
  }

  @override
  void dispose() {
    stateBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Account Details"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)
          )
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              StreamBuilder<Account>(
                stream: stateBloc.accountStateStream,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return _accountHeader(snapshot.data, context); }

                  return Center(
                    child: Container(
                      width: 50,
                      height: 50,

                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),

              Container(
                margin: EdgeInsets.only(top: 60),
                alignment: Alignment.center,
                child: Text(
                  "Transactions",
                  style: TextStyle(fontSize: 16)
                ),
              ),

              SizedBox(
                height: 500,
                child: StreamBuilder<List<Transaction>>(
                  stream: stateBloc.transactionStateStream,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.none && snapshot.hasData == null){
                      return Container(); }
                    else if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return _buildTransactionRow(snapshot.data[index], context);
                        },
                      );
                    }

                    return Center(
                      child: Container(
                        width: 50,
                        height: 50,

                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTransactionPage(id: widget.id))).then(onRouteBack),
          child: Icon(Icons.add),
        )
      )
    );
  }

  FutureOr onRouteBack(value){
    setState(() {
      stateBloc.accountEventSink.add(AccountAction.Update);
      stateBloc.transactionEventSink.add(TransactionAction.Update);
    });
  }
}

Widget _accountHeader (Account account, BuildContext context){
  return Container(
    child: Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Text(
                  account.name,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  account.nickname,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  account.type,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          )
        ),

        Expanded(
          flex: 5,
          child: Container(
            alignment: Alignment.centerRight,
            child: Column(
              children: [
                Text(
                  account.balance.toString(),
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        )
      ],
    )
  );
}

GestureDetector _buildTransactionRow (Transaction transaction, BuildContext context){
  return GestureDetector(
    child: Container(
      padding: EdgeInsets.all(20),
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
                            fontSize: 14
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
                            fontSize: 14
                          )
                        )
                      )
                    ),

                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          transaction.type,
                          style: TextStyle(
                            fontSize: 14
                          )
                        ),
                      )
                    )
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Text(
                        transaction.description,
                        style: TextStyle(
                          fontSize: 10
                        )
                      ),
                    )
                  ],
                )
              ],
            )
          )
        ],
      ),
    ),
  );
}