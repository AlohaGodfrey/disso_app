import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/Auth.dart';
import '../theme/palette.dart';

class ProfileSearchSliver extends StatefulWidget {
  bool isAdmin;
  TextEditingController searchController;
  Function SearchCity;
  ProfileSearchSliver(
      {this.isAdmin = false,
      required this.searchController,
      required this.SearchCity});
  @override
  _ProfileSearchSliverState createState() => _ProfileSearchSliverState();
}

class _ProfileSearchSliverState extends State<ProfileSearchSliver> {
  @override
  Widget build(BuildContext context) {
    // final isAdmin = Provider.of<Auth>(context).isAdmin; //checks isAdmin?
    Size size = MediaQuery.of(context).size;
    return SliverList(
      delegate: SliverChildListDelegate([
        Stack(children: [
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
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              print(context.read<Auth?>()?.isAdmin);
                            },
                            icon: Icon(Icons.help))
                      ],
                    )
                  ],
                ),
              ),
              Visibility(
                visible: widget.isAdmin,
                child: SizedBox(
                  height: 20,
                ),
              )
            ],
          ),
          Visibility(
            visible: widget.isAdmin,
            child: Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    controller: widget.searchController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Enter a Location?",
                        suffixIcon: IconButton(
                          onPressed: () async {
                            widget.SearchCity();
                          },
                          icon: Icon(Icons.search),
                        ),
                        contentPadding: EdgeInsets.only(left: 20)),
                  ),
                ),
              ),
            ),
          )
        ]),
      ]),
    );
  }
}