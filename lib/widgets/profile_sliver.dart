import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/palette.dart';

class ProfileSliver extends StatefulWidget {
  @override
  _ProfileSliverState createState() => _ProfileSliverState();
}

class _ProfileSliverState extends State<ProfileSliver> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SliverList(
      delegate: SliverChildListDelegate([
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: size.height / 7,
              decoration: const BoxDecoration(
                  color: Palette.kToLight,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(45),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(136, 212, 212, 212),
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ]),
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
                      SizedBox(
                        width: size.width * 0.12,
                      ),
                      Column(
                        children: [
                          Text(
                            'Immanuel Godfrey',
                            // style: TextStyle(
                            //     color: Colors.white,
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 16),
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black54),
                              child: Text(
                                '  TM Operative  ',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
