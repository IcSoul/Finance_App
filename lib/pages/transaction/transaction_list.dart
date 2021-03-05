import 'dart:async';

import 'package:finance_app/pages/transaction/transaction_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:finance_app/model/transaction.dart';
import 'package:finance_app/controller/controller_transaction.dart';

import 'package:finance_app/shared/widgets.dart';


class TransactionListPage extends StatefulWidget {
  final int id;
  
  TransactionListPage({Key key, @required this.id}) : super(key: key);
  
  @override
  _State createState() => _State();
}

class _State extends State<TransactionListPage> {
  final TransactionBloc _transactionBloc = TransactionBloc();
  
  @override 
  void initState(){
    _transactionBloc.listEventSink.add(widget.id);
    super.initState();
  }
  
  @override
  void dispose(){
    _transactionBloc.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: StreamBuilder<List<Transaction>>(
          stream: _transactionBloc.listStateStream,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.none && snapshot.hasData == null){
              return Container(); }
            else if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: () => Get.to(() => ViewTransactionPage(id: snapshot.data[index].id)).then(onRouteBack),
                    child: listTransactionRow(snapshot.data[index]),
                  );
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
      ),
    );
  }
  
  FutureOr onRouteBack(value){
    setState(() => _transactionBloc.listEventSink.add(widget.id));
  }
}