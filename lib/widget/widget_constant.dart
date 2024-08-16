import 'package:expense_manager/controller/insertController.dart';
import 'package:expense_manager/view/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget datePick(context, bool time, {title, onpress, color}) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(02), // Set border radius here
      ),
    ),
    onPressed: onpress,
    icon: Icon(
      time ? CupertinoIcons.clock : Icons.calendar_month,
      color: Theme.of(context).highlightColor,
    ),
    label: Text(
      title != null ? title : "Date",
      style: TextStyle(fontSize: 14, color: color),
    ),
  );
}

Widget commonGraphs(context, bool monthlyClick, InsertController controller) {
  return SfCartesianChart(
    series: [
      SplineAreaSeries<SalesData, String>(
        dataSource: monthlyClick
            ? List.generate(controller.monthly_expenses.length, (index) {
                return SalesData(
                    controller.monthly_expenses[index]['month'],
                    double.parse(controller.monthly_expenses[index]['total']
                        .toString()));
              })
            : List.generate(controller.daily_expenses.length, (index) {
                final dateString =
                    controller.daily_expenses[index]['date'] as String;
                final parsedDate = DateFormat('yyyy-MM-dd').parse(dateString);
                final formattedDate = DateFormat('EEE').format(parsedDate);
                return SalesData(
                    formattedDate,
                    double.parse(
                        controller.daily_expenses[index]['total'].toString()));
              }),
        xValueMapper: (SalesData sales, _) => sales.year,
        yValueMapper: (SalesData sales, _) => sales.sales,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            color: Color.fromARGB(115, 4, 4, 4),
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        gradient: LinearGradient(
          end: Alignment.topCenter,
          begin: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColorLight.withOpacity(0.0),
            Theme.of(context).primaryColor,
          ],
        ),
        borderColor: Theme.of(context).primaryColor,
        borderWidth: 2,
      ),
    ],
    primaryXAxis: CategoryAxis(
      isVisible: true,
      majorGridLines: MajorGridLines(
          color: Theme.of(context)
              .focusColor), // Set the color of the x-axis lines
      majorTickLines: MajorTickLines(color: Theme.of(context).focusColor),
    ),
    primaryYAxis: NumericAxis(
      isVisible: false,
      majorGridLines: MajorGridLines(
          color: Theme.of(context)
              .focusColor), // Set the color of the y-axis lines
      majorTickLines: MajorTickLines(color: Theme.of(context).focusColor),
    ),
  );
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
