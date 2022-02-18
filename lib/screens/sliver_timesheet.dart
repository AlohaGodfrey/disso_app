import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_sliver.dart';

import '../widgets/app_drawer.dart';
import '../providers/jobs.dart';
import '../widgets/job_card.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/timesheet.dart' show Timesheet;
import '../widgets/timesheet_card.dart';
import '../widgets/app_drawer.dart';

class SliverTimesheet extends StatelessWidget {
  static const routeName = '/sliver-timesheet';

  @override
  Widget build(BuildContext context) {
    final timesheetHistory = Provider.of<Timesheet>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text('Digital Timesheet'),
          ),
          ProfileSliver(),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.separated(
                  //annoying bug where there is default padding. Phantom space
                  padding: const EdgeInsets.only(top: 0, bottom: 80),
                  physics: const BouncingScrollPhysics(),
                  itemCount: timesheetHistory.timesheet.length,
                  itemBuilder: (ctx, index) {
                    return TimesheetItem(timesheetHistory.timesheet[index]);
                  },

                  // physics: ClampingScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
