int currentWeekNumber() {
  DateTime now = DateTime.now();
  var from = DateTime(now.year, 1, 1);
  var to = DateTime(now.year, now.month, now.day);
  return (to.difference(from).inDays / 7).ceil();
}