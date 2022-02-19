import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:provider/provider.dart';

import '../providers/timesheet.dart';
import '../theme/palette.dart';
import '../models/job.dart';

//shows a custom dialog and transfer job data
void activeJobDone(
    {required BuildContext context,
    required Job activeJob,
    required Stopwatch stopwatch,
    required bool earlyFinish,
    required CountDownController clockController}) {
  String title;
  String text;
  if (earlyFinish) {
    title = 'Shift Complete';
    text = 'Press Ok to save a digital timesheet';
  } else {
    title = 'Clocking Out';
    text = 'Do you want to end your shift?';
  }
  //pause time on dialog popup
  clockController.pause();
  stopwatch.stop();

  CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      backgroundColor: Palette.bToDark,
      title: title,
      text: text,
      onConfirmBtnTap: () async {
        final timeWorked = stopwatch.elapsed.inSeconds;
        print(stopwatch.elapsed);
        print(timeWorked);
        await Provider.of<Timesheet>(context, listen: false)
            .addJobX(activeJob, timeWorked.toDouble());
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      onCancelBtnTap: () {
        clockController.resume();
        stopwatch.start();
        Navigator.of(context).pop();
      });
}
