import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/job_list_screen.dart';
import '../screens/timesheet_screen.dart';
import '../screens/sliver_joblist.dart';
import '../screens/sliver_timesheet.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Disso'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            // leading: Icon(Icons.content_paste_search_rounded),
            leading: Icon(Icons.search),
            title: Text('Search Jobs'),
            onTap: () {
              Navigator.of(context).pushNamed(SliverJobList.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text('Timesheets'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SliverTimesheet.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop(); //closes drawer
              //navigate to homescreen
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false)
                  .logout(); //logs out user
            },
          ),
        ],
      ),
    );
  }
}
