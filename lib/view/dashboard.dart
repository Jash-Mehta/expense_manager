import 'package:expense_manager/controller/date_filterController.dart';
import 'package:expense_manager/controller/deleteController.dart';
import 'package:expense_manager/controller/insertController.dart';
import 'package:expense_manager/view/add_expense.dart';
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
  @override
  void initState() {
    super.initState();
    getExpenses.getExpenses();
    getExpenses.getDailyTotal(DateFormat('yyyy-MM-dd').format(startDate),
        DateFormat('yyyy-MM-dd').format(endDate));
  }

  startDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
      // barrierColor: Theme.of(context).highlightColor,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().add(const Duration(days: -(365 * 5))),
      lastDate: DateTime.now(),
    );

    setState(() {
      startDate = selectedDate as DateTime;
      formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    });

    return formattedStartDate;
  }

  endDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().add(const Duration(days: -(365 * 5))),
      lastDate: DateTime.now(),
    );

    setState(() {
      endDate = selectedDate!;
      formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    });

    return endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.notifications),
          )
        ],
      ),
      body:
          GetBuilder<InsertController>(builder: (InsertController controller) {
        return Column(
          children: [
            SfCartesianChart(
              series: [
                ColumnSeries<SalesData, String>(
                  dataSource:
                      List.generate(controller.daily_expenses.length, (index) {
                    final dateString =
                        controller.daily_expenses[index]['date'] as String;
                    final parsedDate =
                        DateFormat('yyyy-MM-dd').parse(dateString);
                    final formattedDate = DateFormat('dd').format(parsedDate);
                    return SalesData(
                        formattedDate,
                        double.parse(controller.daily_expenses[index]['total']
                            .toString()));
                  }),
                  width: 0.5,
                  borderWidth: 0.3,
                  xValueMapper: (SalesData sales, _) => sales.year,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold)),
                  gradient: LinearGradient(
                      end: Alignment.topCenter,
                      begin: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).highlightColor,
                        Theme.of(context).primaryColor,
                      ]),
                ),
              ],
              primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(
                    color: Theme.of(context)
                        .focusColor), // Set the color of the x-axis lines
                majorTickLines:
                    MajorTickLines(color: Theme.of(context).focusColor),
              ),
              primaryYAxis: NumericAxis(
                  majorGridLines: MajorGridLines(
                      color: Theme.of(context)
                          .focusColor), // Set the color of the x-axis lines
                  majorTickLines:
                      MajorTickLines(color: Theme.of(context).focusColor)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "Daily Expenses",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "From".padRight(6),
                ),
                datePick(context, false,
                    title: formattedStartDate.isNotEmpty
                        ? formattedStartDate
                        : null,
                    color: Theme.of(context).highlightColor, onpress: () {
                  if (formattedEndDate.isNotEmpty) {
                    datefilterController.dateFilterController(
                        formattedStartDate, formattedEndDate);
                    filterStatus = true;
                    setState(() {});
                  }
                  startDatePicker();
                }),
                const SizedBox(width: 5),
                Text(
                  "To".padRight(4),
                ),
                datePick(context, false,
                    title:
                        formattedEndDate.isNotEmpty ? formattedEndDate : null,
                    color: Theme.of(context).highlightColor, onpress: () {
                  if (formattedStartDate.isNotEmpty) {
                    datefilterController.dateFilterController(
                        formattedStartDate, formattedEndDate);
                    filterStatus = true;
                    setState(() {});
                  }
                  endDatePicker();
                }),
              ],
            ),
            Expanded(
                child: ListView.builder(
              itemCount: filterStatus
                  ? datefilterController.filterDateExpenses.length
                  : controller.allExpenses.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onLongPress: () {
                    deleteExpenses
                        .deleteExpense(controller.allExpenses[index]['id']);
                  },
                  leading: Container(
                    height: 60.0,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 105, 102, 102),
                    ),
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Icon(
                      Icons.receipt,
                      size: 40,
                      color: Theme.of(context).highlightColor,
                    ),
                  ),
                  title: Text(controller.allExpenses[index]['description'],
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor)),
                  subtitle: Text(controller.allExpenses[index]['date']),
                  trailing: Text(
                      "₹ ${controller.allExpenses[index]['amount'].toString()}",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor)),
                );
              },
            ))
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(
            Icons.receipt,
            color: Theme.of(context).highlightColor,
          ),
          onPressed: () {
            Get.to(const AddExpenseUI());
          },
          label: Text(
            "Add Expense",
            style: TextStyle(color: Theme.of(context).highlightColor),
          )),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
