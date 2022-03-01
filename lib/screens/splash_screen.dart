import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';

import '../theme/palette.dart';
import '../theme/clip_shadow_path.dart';
import '../theme/custom_clippers_bezier.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
          ),
        ],
      ),
    );
  }
}
