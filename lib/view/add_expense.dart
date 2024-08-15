import 'package:expense_manager/controller/insertController.dart';
import 'package:expense_manager/widget/widget_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddExpenseUI extends StatefulWidget {
  const AddExpenseUI({super.key});

  @override
  State<AddExpenseUI> createState() => _AddExpenseUIState();
}

class _AddExpenseUIState extends State<AddExpenseUI> {
  final addexpense = Get.put(InsertController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController descriptionText = TextEditingController();
  TextEditingController amountText = TextEditingController();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  String formattedStartDate = "";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Add Expenses",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  addexpense.insertExpense(descriptionText.text,
                      int.parse(amountText.text), formattedStartDate);
                  addexpense.updateDailyTotal(
                      formattedStartDate, double.parse(amountText.text));
                },
                icon: const Icon(Icons.check))
          ],
        ),
        body: GetBuilder<InsertController>(
            builder: (InsertController controller) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 217, 215, 215),
                            border: Border.all(color: Colors.black)),
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.receipt,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                          margin: const EdgeInsets.only(right: 50.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 2.5,
                                  color: Color.fromARGB(255, 93, 93, 93)),
                            ),
                          ),
                          child: TextFormField(
                            controller: descriptionText,
                            decoration: const InputDecoration(
                                hintText: "Enter Description",
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none),
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 217, 215, 215),
                            border: Border.all(color: Colors.black)),
                        margin: EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.attach_money_rounded,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                          margin: const EdgeInsets.only(right: 50.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 2.5,
                                  color: Color.fromARGB(255, 93, 93, 93)),
                            ),
                          ),
                          child: TextFormField(
                            controller: amountText,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: "Enter Amount",
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none),
                          )),
                    )
                  ],
                ),
                datePick(context, false,
                    title: formattedStartDate.isNotEmpty
                        ? formattedStartDate
                        : null,
                    color: Theme.of(context).highlightColor, onpress: () {
                  startDatePicker();
                })
              ],
            ),
          );
        }));
  }
}
