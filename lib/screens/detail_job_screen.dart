import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../routes/routes.dart';

import '../models/job_model.dart';
import '../widgets/details_job_widgets.dart';
import '../widgets/location_input.dart';
import '../helpers/location_service.dart';
import '../theme/palette.dart';
import '../providers/auth.dart';
import '../providers/jobs_firebase.dart';
import '../widgets/show_dialog.dart';

class DetailJobScreen extends StatelessWidget {
  // bool jobDelete = false;
  final Job currentJob;
  final Function refreshJobList;
  const DetailJobScreen(this.currentJob, this.refreshJobList, {Key? key})
      : super(key: key);

  //get the job id to enter the data before sending it to be rendered

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<Auth>(context).isAdmin; //checks isAdmin?
    // final Job currentJob = ModalRoute.of(context)!.settings.arguments as Job;

    // Provider.of<Jobs>(context, listen: false).fetchAndSetJobs();
    final _previewImageUrl = LocationService.generateLocationPreviewImage(
        latitute: currentJob.location.latitude,
        longitude: currentJob.location.longitude);

    //screen size optimizations
    var deviceSize = MediaQuery.of(context).size;
    bool isSmallScreen = deviceSize.width > 650;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${currentJob.title} Site',
        ),
        actions: [
          Visibility(
            visible: isAdmin,
            child: IconButton(
              onPressed: () {
                //show pop up confirmation
                confirmJobDelete(context, currentJob, refreshJobList);
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          Visibility(
            visible: isAdmin,
            child: IconButton(
              onPressed: () {
                //edit the current item.
                Navigator.of(context).pushNamed(RouteManager.editJobScreen,
                    arguments: currentJob.id);
              },
              icon: const Icon(Icons.edit),
            ),
          )
        ],
      ),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          jobDetailPanel(currentJob, deviceSize),
          const SizedBox(width: 10),
          Container(
            // height: 265,
            // height: de * 0.3,
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            // margin: const EdgeInsets.all(12),
            margin: isSmallScreen
                ? EdgeInsets.symmetric(horizontal: deviceSize.width * 0.2)
                : const EdgeInsets.all(12),

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(136, 212, 212, 212),
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  ),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location | ${currentJob.title} ${currentJob.postcode}',
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(child: LocationInput(_previewImageUrl)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    transportIconFinder(currentJob.vehicleRequired),
                    googleFontStyle(' | '),
                    transportInfo(currentJob.vehicleRequired),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Requirements',
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                googleFontStyle(
                    '\u2022 Wear Personal Protective Equipment at all times'),
                googleFontStyle('\u2022 No Phones Allowed on site '),
                googleFontStyle(
                    '\u2022 Must have Streetwork(NRSWA) ID Avaialble'),
                googleFontStyle(
                    '\u2022 Report hazardous working conditions to supervisor'),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                  RouteManager.activeJobScreen,
                  arguments: currentJob);
            },
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              // margin: const EdgeInsets.all(12),
              margin: isSmallScreen
                  ? EdgeInsets.symmetric(
                      horizontal: deviceSize.width * 0.2, vertical: 12)
                  : const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Palette.bToDark, Palette.kToDark]),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(136, 212, 212, 212),
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  ),
                ],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(""),
                    const Text(
                      "Clock In",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(
                          Icons.arrow_right_alt_outlined,
                          size: 25.0,
                          color: Colors.green,
                        ))
                  ]),
            ),
          )
        ],
      ),
    );
    //   },
    // );
  }
}
