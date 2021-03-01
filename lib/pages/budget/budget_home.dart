import 'package:flutter/material.dart';

class BudgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Budgets"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          )
        ),
        body: _context
      )
    );
  }
}

Widget _context = Container();