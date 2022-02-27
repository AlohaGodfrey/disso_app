class TimesheetItem {
  final String id;
  final String siteName;
  final DateTime date;
  final double hoursWorked;
  final double payRate;

  TimesheetItem(
      {required this.id,
      required this.siteName,
      required this.date,
      required this.hoursWorked,
      required this.payRate});
}
