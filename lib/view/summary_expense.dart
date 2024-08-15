import 'package:flutter/material.dart';

class SummaryExpensesUI extends StatefulWidget {
  const SummaryExpensesUI({super.key});

  @override
  State<SummaryExpensesUI> createState() => _SummaryExpensesUIState();
}

class _SummaryExpensesUIState extends State<SummaryExpensesUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Summary Expenses",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.history),
          )
        ],
      ),
      body: Column(children: [
     
      ],),
    );
  }
}
