import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../theme/clip_shadow_path.dart';
import '../theme/custom_clippers_bezier.dart';
import '../theme/palette.dart';

class SplashScreen extends StatelessWidget {
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
          Center(
            child: LoadingAnimationWidget.inkDrop(
                color: Palette.bToLight, size: 25),
            // child: CircularProgressIndicator(
            //   strokeWidth: 2,
            //   color: Palette.bToLight,
            //   backgroundColor: Palette.bToLight.shade700,
            // ),
          ),
        ],
      ),
    );
  }
}
