import 'package:expense_manager/controller/insertController.dart';
import 'package:expense_manager/widget/widget_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddExpenseUI extends StatefulWidget {
  const AddExpenseUI({super.key});

  @override
  State<AddExpenseUI> createState() => _AddExpenseUIState();
}

class _AddExpenseUIState extends State<AddExpenseUI> {
  final addexpense = Get.put(InsertController());

  TextEditingController descriptionText = TextEditingController();
  TextEditingController amountText = TextEditingController();
  DateTime startDate = DateTime.now();
  String formattedStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  startDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        startDate = selectedDate;
        formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).highlightColor,
        title: Text(
          "Add Expense",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (descriptionText.text.isNotEmpty &&
                  amountText.text.isNotEmpty) {
                addexpense.insertExpense(
                  descriptionText.text,
                  int.parse(amountText.text),
                  formattedStartDate,
                );
                addexpense.updateDailyTotal(
                  formattedStartDate,
                  double.parse(amountText.text),
                );
                Navigator.pop(context); // Close the screen after saving
              } else {
                // Show an error message if fields are empty
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            icon: const Icon(Icons.check, size: 30),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description Field
              Text(
                "Description",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: descriptionText,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Description",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Amount Field
              Text(
                "Amount",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: amountText,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Amount",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date Picker
              Text(
                "Date",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: startDatePicker,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).primaryColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedStartDate,
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
