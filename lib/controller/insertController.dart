import 'package:expense_manager/Model/insertData.dart';
import 'package:expense_manager/sql/add_expenseDB.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class InsertController extends GetxController {
  List<dynamic> allExpenses = [];
  List<dynamic> daily_expenses = [];
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  String formattedStartDate = "";
  String formattedEndDate = "";
Future<void> insertExpense(
  String description, 
  int amount, 
  String date
) async {
  final db = await initDatabase();
  try {
   
    AddExpenses expense = AddExpenses(
      description: description, 
      amount: amount, 
      date: date,
    );

  
    await db.insert(
      'expenses',
      expense.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );


    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);


    String month = DateFormat('MMMM').format(parsedDate);
    int year = parsedDate.year;

    // Check if the monthly total already exists
    final List<Map<String, dynamic>> existing = await db.query(
      'monthly_totals',
      where: 'month = ? AND year = ?',
      whereArgs: [month, year],
    );

    if (existing.isNotEmpty) {
      // Update the existing monthly total
      final total = existing.first['total'] + amount;
      await db.update(
        'monthly_totals',
        {'total': total},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      // Insert a new monthly total entry
      await db.insert('monthly_totals', {
        'month': month,
        'year': year,
        'total': amount,
      });
    }


    Get.back();

    getExpenses();
    getDailyTotal(
      DateFormat('yyyy-MM-dd').format(startDate),
      DateFormat('yyyy-MM-dd').format(endDate),
    );
  } catch (e) {
    print(e);
  }
}

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await initDatabase();
    allExpenses.clear();
    allExpenses.addAll(await db.query('expenses'));
    update();
    return await db.query('expenses');
  }

  Future<Map<String, dynamic>?> getDailyTotal(String start, String end) async {
    final db = await initDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'daily_totals',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start, end],
    );
    daily_expenses.clear();
    daily_expenses.addAll(result);
    update();
    return result.isNotEmpty ? result.first : null;
  }

  // Update the daily total expense
  Future<void> updateDailyTotal(String date, double amount) async {
    final db = await initDatabase();

    List<Map<String, dynamic>> result = await db.query(
      'daily_totals',
      where: 'date = ?',
      whereArgs: [date],
    );

    if (result.isNotEmpty) {
      double currentTotal = result.first['total'];
      double newTotal = currentTotal + amount;
      await db.update(
        'daily_totals',
        {'total': newTotal},
        where: 'date = ?',
        whereArgs: [date],
      );
    } else {
      await db.insert(
        'daily_totals',
        {'date': date, 'total': amount},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
