import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/timesheet.dart' show Timesheet;
import '../widgets/timesheet_card.dart';
import '../widgets/app_drawer.dart';

class TimesheetScreen extends StatelessWidget {
  static const routeName = '/timesheet';

  @override
  Widget build(BuildContext context) {
    final timesheetHistory = Provider.of<Timesheet>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Timesheet'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: timesheetHistory.timesheet.length,
        itemBuilder: (ctx, index) =>
            TimesheetItem(timesheetHistory.timesheet[index]),
      ),
    );
  }
}
