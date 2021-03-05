import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'package:get/get.dart';

void main() => runApp(FinanceApp());

class FinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Finance App",
      darkTheme: ThemeData.dark(),
      home : Scaffold (
        body: HomePage()
      )
    );
  }
}