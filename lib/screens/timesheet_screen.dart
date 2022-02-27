import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_bar_sliver.dart';

import '../widgets/app_drawer.dart';
import '../providers/auth.dart';
import '../providers/timesheet.dart' show Timesheet;
import '../widgets/timesheet_card.dart';
import '../widgets/timesheet_pdf_invoice.dart';

class TimesheetScreen extends StatefulWidget {
  static const routeName = '/sliver-timesheet';

  @override
  State<TimesheetScreen> createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends State<TimesheetScreen> {
  late Future _timesheetFuture;
  Future _obtaintimesheetFuture() {
    return Provider.of<Timesheet>(context, listen: false)
        .fetchAndSetTimesheet();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //assigned once state is init
    _timesheetFuture = _obtaintimesheetFuture();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin =
        Provider.of<Auth>(context, listen: false).isAdmin; //checks isAdmin?
    // final timesheetHistory = Provider.of<Timesheet>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Digital Timesheet'),
            actions: [
              //disables pdf button if timesheet history is empty
              //if timesheet history is null then disable pdf button
              IconButton(
                onPressed: () async {
                  if (context.read<Timesheet?>()?.timesheet.isNotEmpty ??
                      true) {
                    generatePDF(context.read<Timesheet>().timesheet);
                  } else {
                    print(false);
                  }
                },
                icon: const Icon(Icons.picture_as_pdf_rounded),
              ),
            ],
          ),
          ProfileBarSliver(isAdmin: isAdmin),
          SliverList(
            delegate: SliverChildListDelegate([
              FutureBuilder(
                  future: _timesheetFuture,
                  builder: (ctx, dataSnapshot) {
                    if (dataSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (dataSnapshot.error != null) {
                      return const Center(
                        child: Text('An error occurred!'),
                      );
                    } else if (dataSnapshot.data != null) {
                      return const Center(
                        child: Text('No Order History'),
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Consumer<Timesheet>(
                          builder: (ctx, timesheetData, child) =>
                              ListView.separated(
                            //annoying bug where there is default padding. Phantom space
                            padding: const EdgeInsets.only(top: 0, bottom: 80),
                            physics: const BouncingScrollPhysics(),
                            itemCount: timesheetData.timesheet.length,
                            itemBuilder: (ctx, index) {
                              return TimesheetItem(
                                  timesheetData.timesheet[index]);
                            },

                            // physics: ClampingScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 0,
                              );
                            },
                          ),
                        ),
                      );
                    }
                  })
            ]),
          ),
        ],
      ),
    );
  }
}
