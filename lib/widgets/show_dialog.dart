import 'dart:core';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:provider/provider.dart';

import '../providers/timesheets_firebase.dart';
import '../providers/jobs_firebase.dart';
import '../theme/palette.dart';
import '../models/job_model.dart';

enum HelpHintType { listAdmin, listUser, editJob, timesheet, mapsGoogle }

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('An Error Occurred!'),
      content: Text(message),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Okay'))
      ],
    ),
  );
}

//shows a custom dialog and transfer job data
void activeJobDone(
    {required BuildContext context,
    required Job activeJob,
    required Stopwatch stopwatch,
    required bool isEarlyFinish,
    required CountDownController clockController}) {
  String title;
  String text;

  if (isEarlyFinish) {
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
        // final timeWorked = stopwatch.elapsed.inSeconds;
        // final timeWorked = _calculateTimeWorked(clockController);
        final timeWorked =
            TimesheetsFirebase.calculateTimeWorked(clockController.getTime());
        await Provider.of<TimesheetsFirebase>(context, listen: false)
            .addJobX(activeJob, (timeWorked).toDouble());
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      onCancelBtnTap: () {
        clockController.resume();
        stopwatch.start();
        Navigator.of(context).pop();
      });
}

//confirmation windows for admin requesting job delete
void confirmJobDelete(
    BuildContext context, Job currentJob, Function refreshJobList) {
  CoolAlert.show(
    context: context,
    title: 'Delete Job Entry?',
    text: 'This action cannot be undone',
    type: CoolAlertType.confirm,
    confirmBtnText: 'Delete Job',
    confirmBtnColor: Colors.red,
    backgroundColor: Palette.kToLight,
    onConfirmBtnTap: () async {
      //deletes the item
      await context.read<JobsFirebase>().deleteJob(currentJob.id);
      //navigates back to main joblist
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      //auto-refreshes the main joblist
      await refreshJobList();
    },
  );
}

//timesheet help, location help, job list help, edit job screen
//add new jobs, pull down to refresh, search job sites
void helpContextDialog(BuildContext context, HelpHintType currentScreen) {
  String star = '\n\u{2A}\u{FE0F}';
  String helpTitle = 'No Help Available';
  String helpInfo = 'contact support';
  String helpInfoExtended = '';
  const Key('HelpContextDialog');

  switch (currentScreen) {
    case HelpHintType.listUser:
      helpTitle = 'Search and Select jobs';
      helpInfo =
          '\u{2A}\u{FE0F} Search job list instantly$star Refresh for latest updates';
      helpInfoExtended = '$star View brief job summary';
      break;
    case HelpHintType.listAdmin:
      helpTitle = 'Search and Select jobs';
      helpInfo =
          '\u{2A}\u{FE0F} Search job list instantly$star Refresh for latest updates';
      helpInfoExtended = '$star View brief job summary $star Add new jobs';
      break;
    case HelpHintType.editJob:
      helpTitle = 'Edit/Add a new job';
      helpInfo =
          '\u{2A}\u{FE0F} Add/Edit a Job$star Enter custom details$star Set Pay Rate';
      helpInfoExtended =
          '$star Select vehicle requirements $star Three Light Configurations';
      break;
    case HelpHintType.mapsGoogle:
      helpTitle = 'View location info';
      helpInfo =
          '\u{2A}\u{FE0F} Interact with dynamic map$star View worker active location';
      helpInfoExtended = '$star Visit any location';
      break;
    case HelpHintType.timesheet:
      helpTitle = 'View Work History';
      helpInfo =
          '\u{2A}\u{FE0F} View Timesheet summary$star Expand timesheet history details';
      helpInfoExtended = '$star Generate a PDF Invoice';
      break;
  }

  CoolAlert.show(
    context: context,
    backgroundColor: Palette.kToLight,
    type: CoolAlertType.info,
    title: helpTitle,
    text: '$helpInfo $helpInfoExtended',
  );
}

void showAuthError(BuildContext context, String error) {
  CoolAlert.show(
    context: context,
    // backgroundColor: Palette.kToLight,
    type: CoolAlertType.error,
    title: 'An Error Occured',
    text: error,
  );
}
