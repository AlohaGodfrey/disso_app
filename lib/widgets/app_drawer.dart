import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import '../routes/routes.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Disso'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search Jobs'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(RouteManager.listJobScreen);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Timesheets'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(RouteManager.timesheetScreen);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.location_history),
            title: const Text('Map Overview'),
            enabled: defaultTargetPlatform != TargetPlatform.windows,
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                RouteManager.mapsGoogleScreen,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              //closes drawer
              Navigator.of(context).pop();
              //navigate to homescreen
              Navigator.of(context).pushReplacementNamed('/');
              //logs out user
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
