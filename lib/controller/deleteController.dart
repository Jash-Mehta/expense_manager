import 'package:expense_manager/controller/insertController.dart';
import 'package:get/get.dart';

import '../sql/add_expenseDB.dart';

class DeleteController extends GetxController {
  final getExpense = Get.put(InsertController());
  Future<void> deleteExpense(int id) async {
    final db = await initDatabase();
    try {
      await db.delete(
        'expenses',
        where: 'id = ?',
        whereArgs: [id],
      ).whenComplete(() => print("Delete Sucessfully"));
      getExpense.getExpenses();
      update();
    } catch (e) {
      print(e);
    }
  }
}
