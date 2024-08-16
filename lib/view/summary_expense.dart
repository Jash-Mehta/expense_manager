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
  final summaryExpense = Get.put(SummaryController());
  final monthlyExpenses = Get.put(InsertController());

  @override
  void initState() {
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
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.history, color: Theme.of(context).primaryColor),
          )
        ],
      ),
      body: GetBuilder<SummaryController>(
        builder: (SummaryController controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSummaryCard(
                  context,
                  "Weekly Expenses",
                  summaryExpense.weeklyExpense.toString(),
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  context,
                  "Monthly Expenses",
                  monthlyExpenses.monthly_expenses.isNotEmpty
                      ? monthlyExpenses.monthly_expenses[0]['total'].toString()
                      : 'N/A',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String amount) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        border: Border.all(color: Theme.of(context).hintColor),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).hintColor,
            ),
          ),
          Text(
            '₹ $amount',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
