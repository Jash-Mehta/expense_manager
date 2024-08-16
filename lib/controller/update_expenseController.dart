import 'package:expense_manager/Model/insertData.dart';
import 'package:expense_manager/controller/insertController.dart';
import 'package:expense_manager/sql/add_expenseDB.dart';
import 'package:get/get.dart';

class UpdateExpenseController extends GetxController {
  var allexpense = Get.put(InsertController());
  Future<void> updateExpensesController(
      int id, String description, String date, var amount) async {
    final db = await initDatabase();
    try {
      AddExpenses expense = AddExpenses(
        description: description,
        amount: amount,
        date: date,
      );
      await db.update(
        'expenses',
        expense.toJson(),
        where: 'id = ?',
        whereArgs: [id],
      );
      update();
      allexpense.getExpenses();
    } catch (e) {
      print('Error updating expense with ID $id: $e');
    }
  }
}
