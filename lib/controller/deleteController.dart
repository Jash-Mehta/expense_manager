import 'package:expense_manager/controller/insertController.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../sql/add_expenseDB.dart';

class DeleteController extends GetxController {
  final getExpense = Get.put(InsertController());
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  String formattedStartDate = "";
  String formattedEndDate = "";
  Future<void> deleteExpense(int id) async {
    final db = await initDatabase();
    try {
      // Fetch the expense details before deleting it
      final expense = await db.query(
        'expenses',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (expense.isNotEmpty) {
        var amount = expense.first['amount'];
        final dateString = expense.first['date'];

        // Parse the date string to a DateTime object
        final date = DateTime.parse(dateString.toString());
        final day = DateFormat('yyyy-MM-dd').format(date);
        final month = DateFormat('MMMM').format(date);
        final year = date.year;

        // Delete the expense from the expenses table
        await db.delete(
          'expenses',
          where: 'id = ?',
          whereArgs: [id],
        );

        // Update the daily_totals table
        final dailyTotal = await db.query(
          'daily_totals',
          where: 'date = ?',
          whereArgs: [day],
        );

        if (dailyTotal.isNotEmpty) {
          var updatedDailyTotal =
              double.parse(dailyTotal.first['total'].toString()) -
                  double.parse(amount.toString());
          if (updatedDailyTotal <= 0) {
            await db.delete(
              'daily_totals',
              where: 'date = ?',
              whereArgs: [day],
            );
            getExpense.getDailyTotal(
              DateFormat('yyyy-MM-dd').format(startDate),
              DateFormat('yyyy-MM-dd').format(endDate),
            );
          } else {
            await db.update(
              'daily_totals',
              {'total': updatedDailyTotal},
              where: 'date = ?',
              whereArgs: [day],
            );
          }
          getExpense.getDailyTotal(
            DateFormat('yyyy-MM-dd').format(startDate),
            DateFormat('yyyy-MM-dd').format(endDate),
          );
          update();
        }

        // Update the monthly_totals table
        final monthlyTotal = await db.query(
          'monthly_totals',
          where: 'month = ? AND year = ?',
          whereArgs: [month, year],
        );

        if (monthlyTotal.isNotEmpty) {
          final updatedMonthlyTotal =
              double.parse(monthlyTotal.first['total'].toString()) -
                  double.parse(amount.toString());
          if (updatedMonthlyTotal <= 0) {
            await db.delete(
              'monthly_totals',
              where: 'month = ? AND year = ?',
              whereArgs: [month, year],
            );
          } else {
            await db.update(
              'monthly_totals',
              {'total': updatedMonthlyTotal},
              where: 'month = ? AND year = ?',
              whereArgs: [month, year],
            );
          }
        }

        getExpense.fetchMonthlyTotals();
        update();
      }
    } catch (e) {
      print(e);
    }
  }
}
