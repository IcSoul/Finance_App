import 'package:flutter/material.dart';

// Page Imports
import 'pages/home.dart';

void main() => runApp(FinanceApp());

class FinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Finance App",
      home : Scaffold (
        body: HomePage()
      )
    );
  }
}