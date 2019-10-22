class AppFilters {
  String category;

  // month data (start and end date).
  int year;
  int month;
  DateTime monthStart;
  DateTime monthEnd;

  AppFilters(
      {this.category, this.month, this.year, this.monthStart, this.monthEnd});

  factory AppFilters.copy(AppFilters copy) {
    return new AppFilters(
      category: copy.category,
      month: copy.month,
      year: copy.year,
      monthStart: copy.monthStart,
      monthEnd: copy.monthEnd,
    );
  }
}
