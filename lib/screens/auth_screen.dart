import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/palette.dart';
import '../theme/clip_shadow_path.dart';
import '../theme/custom_clippers_bezier.dart';
import '../widgets/auth_card.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.kToLight,
      body: Stack(
        children: [
          ClipShadowPath(
            shadow: const BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 4,
              spreadRadius: 8,
            ),
            clipper: BigClipper(),
            child: Container(color: Palette.bToLight),
          ),
          ClipShadowPath(
            shadow: const BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 4,
              spreadRadius: 8,
            ),
            clipper: SmallClipper(),
            child: Container(color: Palette.kToLight),
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        FontAwesomeIcons.clipboardCheck,
                        size: 100,
                        color: Palette.bToLight.shade100,
                      ),
                    ),
                  ),
                  const Flexible(
                    // flex: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    flex: 4,
                    child: AuthCard(),
                    fit: FlexFit.loose,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
