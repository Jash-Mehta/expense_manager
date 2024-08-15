class AddExpenses {
  String description;
  int amount;
  String date;

  AddExpenses({required this.description, required this.amount,required this.date});
  Map<String, dynamic> toJson() {
    return {"description":description,"amount":amount,"date":date};
  }
}
