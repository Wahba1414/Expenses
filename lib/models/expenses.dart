class Expenses {
  String id;
  String title;
  String amount;
  String category;
  DateTime date;
  String mood;

  Expenses({this.id, this.title, this.amount, this.category, this.date,this.mood});

  factory Expenses.fromMap(Map<String, dynamic> json) => new Expenses(
      id: json["id"],
      title: json["title"],
      amount: json["amount"],
      category: json["category"],
      date: DateTime.parse(json["date"]),
      mood: json["mood"]);

  log() {
    print('id: $id');
    print('title: $title');
    print('amount: $amount');
    print('category: $category');
    print('date: $date');
    print('mood: $mood');
  }
}
