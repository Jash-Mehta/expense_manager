import 'package:get/get.dart';

import '../sql/add_expenseDB.dart';

class SummaryController extends GetxController {
  Future<void> fetchWeeklyExpense() async {
    final db = await initDatabase();
    final currentDate = DateTime.now();

    final startOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final results = await db.rawQuery(
      '''
    SELECT SUM(amount) as total FROM expenses 
    WHERE date BETWEEN ? AND ?
    ''',
      [startOfWeek.toIso8601String(), endOfWeek.toIso8601String()],
    );
    print(results[0]['total']);
  }
}
