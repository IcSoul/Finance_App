import 'dart:async';

import 'package:finance_app/model/account.dart';
import 'package:finance_app/pages/account/account_view.dart';
import 'package:finance_app/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/events/account_home_bloc.dart';
import 'package:finance_app/controller/controller_account.dart';
import 'package:get/get.dart';
import 'account_create.dart';

class AccountPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AccountPage> {
  final stateBloc = AccountHomeBloc();
  final AccountBloc _accountBloc = AccountBloc();

  @override
  void initState(){
    _accountBloc.listEventSink.add(EventType.Get);
    super.initState();
  }

  @override
  void dispose() {
    _accountBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text("Accounts"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Get.back()
          )
      ),
      body: Container(
          child: StreamBuilder<List<Account>>(
            stream: _accountBloc.listStateStream,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.none && snapshot.hasData == null){
                return Container(); }
              else if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index){
                      return GestureDetector(
                          onTap: () => Get.to(() => ViewAccountPage(id: snapshot.data[index].id)).then(onRouteBack),
                          child: listAccountRow(snapshot.data[index])
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
          onPressed: () => Get.to(() => CreateAccountPage()).then(onRouteBack),
          child: Icon(Icons.add)
      ),
    );
  }

  FutureOr onRouteBack(value) {
    setState(() => _accountBloc.listEventSink.add(EventType.Get));
  }
}