import 'dart:async';

import 'package:finance_app/model/account.dart';
import 'package:finance_app/pages/account/account_view.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/events/account_home_bloc.dart';

import 'account_create.dart';


class AccountPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AccountPage> {
  final stateBloc = AccountHomeBloc();

  @override
  void initState(){
    stateBloc.eventSink.add(AccountAction.Update);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Accounts"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)
          )
        ),
        body: Container(
          child: StreamBuilder<List<Account>>(
            stream: stateBloc.stateStream,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.none && snapshot.hasData == null){
                return Container(); }
              else if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    //return _buildRow(snapshot.data[index], context);
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAccountPage(id: snapshot.data[index].id))).then(onRouteBack),
                      child: _buildRow(snapshot.data[index], context)
                    );
                  }
                );
              }

              return Center(
                child: Container(
                  width: 50,
                  height: 50,

                  child: CircularProgressIndicator()
                )
              );
            }
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage())).then(onRouteBack),
          child: Icon(Icons.add)
        ),
      )
    );
  }

  FutureOr onRouteBack(value) {
    setState(() {
      stateBloc.eventSink.add(AccountAction.Update);
    });
  }
}

Container _buildRow(Account account, BuildContext context){
  return Container(
    padding: EdgeInsets.all(20),
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
                      style: TextStyle(
                          fontSize: 18
                      )
                    ),
                    Text(account.nickname)
                  ],
                )
            )
        ),

        Expanded(
          flex: 4,
          child: Container(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  Text(
                    account.balance.toString(),
                    style: TextStyle(
                        fontSize: 18
                    )
                  ),
                  Text(account.type)
                ],
              )
          ),
        )
      ],
    ),
  );
}