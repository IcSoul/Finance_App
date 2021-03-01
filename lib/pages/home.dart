import 'package:flutter/material.dart';

// Page Imports
import 'account/account_home.dart';
import 'budget/budget_home.dart';
import 'archive/archive_home.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Finance App",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Home")
        ),
        body: Container(
          padding: EdgeInsets.only(
            left: 20.0
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage())),
                child: _rowContainer(Icons.account_balance, "Accounts")
              ),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetPage())),
                child: _rowContainer(Icons.pie_chart, "Budgets"),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ArchivePage())),
                child: _rowContainer(Icons.archive, "Archived"),
              )
            ],
          )
        )
      )
    );
  }
}

Container _rowContainer(IconData icon, String name){
  return Container(
    padding: const EdgeInsets.all(20.0),
    child: _buildRow(icon, name)
  );
}

Row _buildRow(IconData icon, String name){
  return Row(
    children: [
      Icon(icon),
      Expanded(
        child: Container(
          margin: EdgeInsets.only(
            left: 20
          ),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 20.0
            )
          ),
        ),
      )
    ],
  );
}