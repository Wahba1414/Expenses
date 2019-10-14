class Expenses {
  String id;
  String title;
  String amount;
  String category;
  DateTime date;

  Expenses({this.id, this.title, this.amount, this.category, this.date});

  factory Expenses.fromMap(Map<String, dynamic> json) => new Expenses(
      id: json["id"],
      title: json["title"],
      amount: json["amount"],
      category: json["category"],
      date: DateTime.parse(json["date"]));
}
