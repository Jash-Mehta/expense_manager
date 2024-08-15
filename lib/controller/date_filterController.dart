import 'package:expense_manager/sql/add_expenseDB.dart';
import 'package:get/get.dart';

class DateFilterController extends GetxController {
  List<dynamic> filterDateExpenses = [];
  Future<void> dateFilterController(String start, String end) async {
    final db = await initDatabase();
    try {
      filterDateExpenses.addAll(await db.query(
        'expenses',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [start, end],
      ));
      update();
      
    } catch (e) {
      print(e);
    }
  }
}
