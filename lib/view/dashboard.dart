import 'package:expense_manager/controller/date_filterController.dart';
import 'package:expense_manager/controller/deleteController.dart';
import 'package:expense_manager/controller/insertController.dart';
import 'package:expense_manager/services/notifi_services.dart';
import 'package:expense_manager/view/add_expense.dart';
import 'package:expense_manager/view/summary_expense.dart';
import 'package:expense_manager/widget/widget_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final getExpenses = Get.put(InsertController());
  final deleteExpenses = Get.put(DeleteController());
  final datefilterController = Get.put(DateFilterController());
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  String formattedStartDate = "";
  String formattedEndDate = "";
  bool filterStatus = false;
  bool monthlyClick = false;

  @override
  void initState() {
    super.initState();
    getExpenses.getExpenses();
    getExpenses.getDailyTotal(DateFormat('yyyy-MM-dd').format(startDate),
        DateFormat('yyyy-MM-dd').format(endDate));
    monthlyClick = false;

    // Schedule initial notification after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      NotificationServices()
          .showNotification(title: 'Reminder', body: 'Add your Daily Expenses');
    });
  }

  Future<void> startDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now().add(const Duration(days: -(365 * 5))),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        startDate = selectedDate;
        formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
        filterStatus = true;
      });
    }
  }

  Future<void> endDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime.now().add(const Duration(days: -(365 * 5))),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        endDate = selectedDate;
        formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
        filterStatus = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        title: Text(
          "Dashboard",
          style: TextStyle(color: Theme.of(context).highlightColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Get.to(const SummaryExpensesUI());
            },
            color: Theme.of(context).highlightColor,
          ),
        ],
      ),
      body:
          GetBuilder<InsertController>(builder: (InsertController controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterButton(context, "Weekly", !monthlyClick, () {
                    setState(() {
                      monthlyClick = false;
                    });
                  }),
                  _buildFilterButton(context, "Monthly", monthlyClick, () {
                    controller.fetchMonthlyTotals();
                    setState(() {
                      monthlyClick = true;
                    });
                  }),
                ],
              ),
            ),
            _buildGraphSection(context, controller),
            Expanded(child: _buildExpensesList(context, controller)),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(
          Icons.add,
          color: Theme.of(context).hintColor,
        ),
        onPressed: () {
          Get.to(const AddExpenseUI());
        },
        label: Text(
          "Add Expense",
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String label, bool isActive,
      VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 40.0,
        width: 120.0,
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).primaryColor
              : Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive
                  ? Theme.of(context).highlightColor
                  : Theme.of(context).hintColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGraphSection(BuildContext context, InsertController controller) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: commonGraphs(context, monthlyClick, controller),
        ),
      ),
    );
  }

  Widget _buildExpensesList(BuildContext context, InsertController controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            "Daily Expenses",
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildDateFilters(context),
        Expanded(
          child: GetBuilder<DateFilterController>(
            builder: (DateFilterController datefilterController) {
              final expenses = filterStatus
                  ? datefilterController.filterDateExpenses
                  : controller.allExpenses;

              return ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildExpenseTile(
                      context, controller, expenses, index);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDateFilterButton(
              context, "From", formattedStartDate, startDatePicker),
          const Icon(Icons.arrow_forward, color: Colors.grey),
          _buildDateFilterButton(
              context, "To", formattedEndDate, endDatePicker),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              datefilterController.dateFilterController(
                  formattedStartDate, formattedEndDate);
            },
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilterButton(
      BuildContext context, String label, String? date, VoidCallback onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            const SizedBox(width: 8.0),
            Text(
              date ?? "Select Date",
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseTile(BuildContext context, InsertController controller,
      List<dynamic> expenses, int index) {
    return Dismissible(
      key: Key(expenses[index]['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        deleteExpenses.deleteExpense(expenses[index]['id']);
        controller.allExpenses.removeAt(index);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense deleted')),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: const Color.fromARGB(255, 114, 113, 113),
          child: Icon(
            Icons.receipt,
            color: Theme.of(context).highlightColor,
          ),
        ),
        title: Text(
          expenses[index]['description'],
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).hintColor,
          ),
        ),
        subtitle: Text(
          expenses[index]['date'],
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Text(
          "₹ ${expenses[index]['amount']}",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
