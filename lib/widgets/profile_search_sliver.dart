import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/palette.dart';
import './show_dialog.dart';

enum SearchType { viaSearchButton, viaTextInput }

class ProfileSearchSliver extends StatefulWidget {
  final bool isAdmin;
  final TextEditingController searchController;
  final Function searchFunction;
  final String searchBarHint;
  final SearchType searchType;
  final HelpHintType helpDialog;
  const ProfileSearchSliver(
      {Key? key,
      this.isAdmin = false,
      required this.searchController,
      required this.searchFunction,
      required this.searchBarHint,
      required this.searchType,
      required this.helpDialog})
      : super(key: key);
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        IconButton(
                            onPressed: () {
                              // print(context.read<Auth?>()?.isAdmin);
                              // FocusManager.instance.primaryFocus?.unfocus();
                              if (widget.helpDialog == HelpHintType.listUser &&
                                  widget.isAdmin == true) {
                                helpContextDialog(
                                    context, HelpHintType.listAdmin);
                                return;
                              }
                              helpContextDialog(context, widget.helpDialog);
                            },
                            icon: const Icon(Icons.help))
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: widget.searchType == SearchType.viaSearchButton
                    ? TextFormField(
                        controller: widget.searchController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: widget.searchBarHint,
                            suffixIcon: IconButton(
                              onPressed: () async {
                                widget.searchFunction();
                              },
                              icon: const Icon(Icons.search),
                            ),
                            contentPadding: const EdgeInsets.only(left: 20)),
                      )
                    : TextField(
                        controller: widget.searchController,
                        onChanged: (value) {
                          widget.searchFunction(value);
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: widget.searchBarHint,
                            suffixIcon: IconButton(
                              onPressed: () async {
                                // widget.searchFunction();
                              },
                              icon: const Icon(Icons.search),
                            ),
                            contentPadding: const EdgeInsets.only(left: 20)),
                      ),
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}
