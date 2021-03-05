import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:finance_app/model/account.dart';
import 'package:finance_app/model/transaction.dart';
import 'package:finance_app/pages/transaction/transaction_view.dart';

Widget formTextFieldContainer(Widget widget) =>
    Container(margin: EdgeInsets.only(top: 10), child: widget);

Widget formRadioFieldHeader(String value) => Align(
      alignment: Alignment.centerLeft,
      child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Text(value, style: TextStyle(fontSize: 14))),
    );

Container listAccountRow(Account account) => Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
              flex: 5,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Text(account.name, style: TextStyle(fontSize: 18)),
                      Text(account.nickname)
                    ],
                  ))),
          Expanded(
            flex: 4,
            child: Container(
                alignment: Alignment.centerRight,
                child: Column(
                  children: [
                    Text(account.balance.toString(),
                        style: TextStyle(fontSize: 18)),
                    Text(account.type)
                  ],
                )),
          )
        ],
      ),
    );

Container listTransactionRow(Transaction transaction) => Container(
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
                          child: Text(transaction.date,
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(transaction.amount.toString(),
                                  style: TextStyle(fontSize: 14)))),
                      Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(transaction.type,
                                style: TextStyle(fontSize: 14)),
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: Text(transaction.description,
                            style: TextStyle(fontSize: 10)),
                      )
                    ],
                  )
                ],
              ))
        ],
      ),
    );
