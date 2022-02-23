import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:provider/provider.dart';

import '../providers/timesheet.dart';
import '../providers/Jobs.dart';
import '../theme/palette.dart';
import '../models/job_model.dart';

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

void confirmJobDelete(BuildContext context, Job currentJob) {
  CoolAlert.show(
    context: context,
    title: 'Delete Job Entry?',
    text: 'This action cannot be undone',
    type: CoolAlertType.confirm,
    confirmBtnText: 'Delete Job',
    confirmBtnColor: Colors.red,
    backgroundColor: Palette.kToLight,
    onConfirmBtnTap: () async {
      //refills the provider with server data
      await Provider.of<Jobs>(context, listen: false).fetchAndSetJobs();

      //deletes the current job
      await Provider.of<Jobs>(context, listen: false).deleteJob(currentJob.id);
    },
  );
}
