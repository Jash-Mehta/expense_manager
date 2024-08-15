import 'package:expense_manager/controller/insertController.dart';
import 'package:expense_manager/controller/summary_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryExpensesUI extends StatefulWidget {
  const SummaryExpensesUI({super.key});

  @override
  State<SummaryExpensesUI> createState() => _SummaryExpensesUIState();
}

class _SummaryExpensesUIState extends State<SummaryExpensesUI> {
  var summaryExpense = Get.put(SummaryController());
  var monthlyExpenses = Get.put(InsertController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    summaryExpense.fetchWeeklyExpense();
  }

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
      body: GetBuilder<SummaryController>(
          builder: (SummaryController controller) {
        return Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).hintColor)),
              child: Center(
                  child: Text(
                      "Weekly Expenses:- ${summaryExpense.weeklyExpense}",
                      style: TextStyle(fontSize: 20.0))),
            ),
            Container(
              height: 60,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).hintColor)),
              child: Center(
                  child: Text(
                      "Monthly Expenses:- ${monthlyExpenses.monthly_expenses[0]['total']}",
                      style: TextStyle(fontSize: 20.0))),
            ),
          ],
        );
      }),
    );
  }
}
