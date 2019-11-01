class AppFilters {
  String category;

  // month data (start and end date).
  int year;
  int month;
  DateTime monthStart;
  DateTime monthEnd;

  // New date filters
  DateTime fromDate;
  DateTime toDate;


  AppFilters(
      {this.category, this.month, this.year, this.monthStart, this.monthEnd, this.fromDate, this.toDate});

  factory AppFilters.copy(AppFilters copy) {
    return new AppFilters(
      category: copy.category,
      month: copy.month,
      year: copy.year,
      monthStart: copy.monthStart,
      monthEnd: copy.monthEnd,
      fromDate: copy.fromDate,
      toDate: copy.toDate
    );
  }


  log(){
    print('category:$category');
    print('year:$year');
    print('month:$month');
    print('monthStart:$monthStart');
    print('monthEnd:$monthEnd');
    print('fromDate:$fromDate');
    print('toDate:$toDate');

  }

}
