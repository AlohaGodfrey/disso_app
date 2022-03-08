import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/list_job_screen.dart';
import '../screens/auth_screen.dart';
import '../theme/splash_screen.dart';

class AutoLoginConfig extends StatelessWidget {
  const AutoLoginConfig({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //listens for authentication status change
    final auth = context.watch<Auth>();
    return auth.isAuth
        ? const ListJobScreen()
        : FutureBuilder(
            //attempt to auto login
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapashot) =>
                authResultSnapashot.connectionState == ConnectionState.waiting
                    //show splash screen during the auto-login
                    //attempt. if failed. show auth screen
                    ? const SplashScreen() // : AuthScreen()
                    : const AuthScreen(),
          );
  }
}
