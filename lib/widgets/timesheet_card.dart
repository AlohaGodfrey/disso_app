import 'package:disso_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //used for date format

import 'details_job_widgets.dart';
import '../models/timesheet_model.dart' as pvd;

class TimesheetItem extends StatefulWidget {
  final pvd.TimesheetItem timesheet;
  const TimesheetItem(this.timesheet, {Key? key}) : super(key: key);

  @override
  State<TimesheetItem> createState() => _TimesheetItemState();
}

class _TimesheetItemState extends State<TimesheetItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(136, 212, 212, 212),
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            ),
          ]),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        ListTile(
          title: Text(widget.timesheet.siteName),
          subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(widget.timesheet.date)),
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
        if (_expanded)
          Container(
            height: 80,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      color: Palette.kToLight.shade100,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(136, 212, 212, 212),
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset:
                              Offset(2.0, 2), // shadow direction: bottom right
                        ),
                      ],
                    ),
                    child: Center(
                      child: googleFontStyle(
                          'Rate: £${widget.timesheet.payRate} per hour'),
                    ),
                  ),
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Palette.kToLight.shade300,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(136, 212, 212, 212),
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset:
                              Offset(2.0, 2), // shadow direction: bottom right
                        ),
                      ],
                    ),
                    child: Center(
                      child: googleFontStyle(
                          'Clocked: ${widget.timesheet.hoursWorked} hours'),
                    ),
                  ),
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(16)),
                        color: Palette.kToLight.shade700,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(136, 212, 212, 212),
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(
                                2.0, 2.0), // shadow direction: bottom right
                          ),
                        ]),
                    child: Center(
                      child: googleFontStyle(
                          'Pay: £${widget.timesheet.payRate * widget.timesheet.hoursWorked}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ]),
    );
  }
}
