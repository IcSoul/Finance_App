import 'dart:async';
import 'dart:collection';

import 'package:finance_app/pages/transaction/transaction_view.dart';
import 'package:finance_app/shared/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:finance_app/model/transaction.dart';
import 'package:finance_app/model/account.dart';

import 'package:finance_app/controller/controller_account.dart';
import 'package:finance_app/controller/controller_transaction.dart';

import 'package:finance_app/database/tables/table_account.dart';
import 'package:finance_app/database/tables/table_transaction.dart';

import 'package:finance_app/pages/account/account_edit.dart';
import 'package:finance_app/pages/transaction/transaction_create.dart';

import 'package:finance_app/shared/date.dart';

import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:get/get.dart';

class ViewAccountPage extends StatefulWidget {
  final int id;

  ViewAccountPage({Key key, @required this.id}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ViewAccountPage> {
  final AccountBloc _accountBloc = AccountBloc();
  final TransactionBloc _transactionBloc = TransactionBloc();

  @override
  void initState() {
    _accountBloc.singleEventSink.add(widget.id);
    _transactionBloc.listEventSink.add(widget.id);

    super.initState();
  }

  @override
  void dispose() {
    _accountBloc.dispose();
    _transactionBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Account Details"),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Get.back()
            )
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<Account>(
                  stream: _accountBloc.singleStateStream,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return _accountHeader(snapshot.data, context, onRouteBack); }

                    return Center(
                      child: Container(
                        width: 50,
                        height: 50,

                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),

                StreamBuilder2(
                    streams: Tuple2(_accountBloc.singleStateStream, _transactionBloc.listStateStream),
                    builder: (context, snapshot) {
                      if(snapshot.item1.hasData && (snapshot.item2.hasData && snapshot.item2.data.length > 0)){
                        return Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 1.70,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(18)
                                  ),
                                  color: Color(0xff232d37),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 18,
                                      left: 12,
                                      top: 24,
                                      bottom: 12
                                  ),
                                  child: LineChart(
                                      _mainChartData(_getData(snapshot.item1.data, snapshot.item2.data))
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }

                      return Center(
                        child: Container(
                          width: 50,
                          height: 50,

                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
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
                  height: 700,
                  child: StreamBuilder<List<Transaction>>(
                    stream: _transactionBloc.listStateStream,
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.none && snapshot.hasData == null){
                        return Container(); }
                      else if(snapshot.hasData){
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
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
                )
              ],
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => CreateTransactionPage(id: widget.id)).then(onRouteBack),
          child: Icon(Icons.add),
        ),
    );
  }

  FutureOr onRouteBack(value){
    setState(() {
      _accountBloc.singleEventSink.add(widget.id);
      _transactionBloc.listEventSink.add(widget.id);
    });
  }
}

Widget _accountHeader (Account account, BuildContext context, FutureOr routeBack){
  return Container(
    padding: EdgeInsets.only(bottom: 20),
    child: Row(
      children: [
        Expanded(
          flex: 10,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        account.name,
                        style: TextStyle(
                          fontSize: 24
                        )
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(() => EditAccountPage(account: account)).then(routeBack),
                          child: Icon(Icons.edit),
                        ),

                        SizedBox(width: 10),

                        GestureDetector(
                          onTap: () => _deleteAccountDialog(context, account),
                          child: Icon(Icons.delete),
                        )
                      ],
                    ),
                  )
                ],
              ),

              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  account.balance.toString(),
                  style: TextStyle(
                    fontSize: 20
                  )
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Future _deleteAccountDialog(BuildContext context, Account account) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text("Delete Account"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text("Are you sure you want to delete this account?"),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "*All transactions associated with this account will be removed!",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12
                  ),
                ),
              )
            ],
          )
        ),
        actions: [
          TextButton(
            child: Text("Confirm"),
            onPressed: (){
              Navigator.of(context).pop();
              Get.back();

              AccountTable().deleteAccount(account.id);
              TransactionTable().deleteTransactions(account.id);
            }),

          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop()
          )
        ],
      );
    }
  );
}

LineChartData _mainChartData(List<FlSpot> data) {
  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1
        );
      },

      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1
        );
      }
    ),

    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff68737d),
          fontWeight: FontWeight.bold,
          fontSize: 16
        ),
        getTitles: (value) {
          DateTime now = Date.getCurrentDate(7 - value.toInt());
          return Date.getDayAbbreviation(now.weekday);
        },
        margin: 8
      ),

      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '10k';
            case 3:
              return '30k';
            case 5:
              return '50k';
          }
          return '';
        },
        reservedSize: 28,
        margin: 12
      )
    ),

    borderData: FlBorderData(
      show: true,
      border: Border.all(
        color: const Color(0xff37434d),
        width: 1
      )
    ),

    minX: 0,
    maxX: 7,
    minY: 0,
    maxY: 6,

    lineBarsData: [
      LineChartBarData(
        spots: data,
        isCurved: true,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false
        ),
        belowBarData: BarAreaData(
          show: true
        )
      )
    ]
  );
}

List _getData(Account account, List<Transaction> transaction){
  List data = <FlSpot>[];
  Map<double, double> dataToAdd = new HashMap();

  int index = 0;
  double running = account.balance;
  double highest = running;

  while(index < 8){
    DateTime date = Date.getCurrentDate(7 - index);

    if(index > 0){
      transaction.forEach((item) {
        if(Date.isSameDate(date, DateTime.parse(item.date))){
          running = item.type.toLowerCase() == "debit"
              ? running + item.amount : running - item.amount;

          if(running > highest) highest = running;
        }
      });
    }

    dataToAdd[index.toDouble()] = running;
    index++;
  }

  dataToAdd.forEach((key, value) {
    data.add(FlSpot(key, 6 * (value / highest)));
  });

  return data;
}