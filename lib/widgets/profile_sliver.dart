import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/palette.dart';
import './show_dialog.dart';

class ProfileSliver extends StatefulWidget {
  //bool flag used to load different text depending on user isAdmin permission
  final bool isAdmin;
  final HelpHintType helpDialog;
  const ProfileSliver(
      {Key? key, this.isAdmin = false, required this.helpDialog})
      : super(key: key);
  @override
  _ProfileSliverState createState() => _ProfileSliverState();
}

class _ProfileSliverState extends State<ProfileSliver> {
  @override
  Widget build(BuildContext context) {
    //screen size optimizations
    var deviceSize = MediaQuery.of(context).size;
    bool isSmallScreen = deviceSize.width > 650;
    return SliverList(
      delegate: SliverChildListDelegate([
        Column(
          children: [
            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 15),
              padding: isSmallScreen
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.symmetric(horizontal: 15),
              height: isSmallScreen ? 60 : deviceSize.height / 7,
              decoration: BoxDecoration(
                  color: Palette.kToLight,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(45),
                  ),
                  boxShadow: [
                    isSmallScreen
                        ? const BoxShadow(
                            color: Color.fromRGBO(246, 246, 246, 1))
                        : const BoxShadow(
                            color: Color.fromARGB(136, 212, 212, 212),
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(2.0, 2.0),
                          ),
                  ]),
              child: Visibility(
                visible: !isSmallScreen,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white70,
                          radius: 35,
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/profile.jpg'),
                            radius: 30,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            widget.isAdmin
                                ? Text(
                                    'Admin Account',
                                    style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )
                                : Text(
                                    'Traffic Management',
                                    style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black54),
                                child: widget.isAdmin
                                    ? const Text(
                                        '  Supervisor  ',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : const Text(
                                        '  Operative  ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: deviceSize.width * 0.02,
                        ),
                        IconButton(
                            onPressed: () {
                              // print(context.read<Auth?>()?.isAdmin);
                              helpContextDialog(context, widget.helpDialog);
                            },
                            icon: const Icon(Icons.help))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
