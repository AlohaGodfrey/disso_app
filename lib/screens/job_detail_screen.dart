import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; //format date

import '../models/Job.dart';
import '../widgets/job_details_text.dart';
import '../widgets/location_input.dart';
import '../helpers/location_helper.dart';
import '../theme/palette.dart';
import '../screens/job_active_screen.dart';

class JobDetailScreen extends StatelessWidget {
  static const routeName = '/job-detail';

  //get the job id to enter the data before sending it to be rendered

  @override
  Widget build(BuildContext context) {
    final Job currentJob = ModalRoute.of(context)!.settings.arguments as Job;
    // final jobData = Provider.of<Jobs>(context, listen: false).findById(id);
    final _previewImageUrl = LocationHelper.generateLocationPreviewImage(
        latitute: currentJob.location.latitude,
        longitude: currentJob.location.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${currentJob.title} Site',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          jobDetailPanel(currentJob),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 265,
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(136, 212, 212, 212),
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location | ${currentJob.title}',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LocationInput(_previewImageUrl),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.directions_car),
                      Icon(Icons.bike_scooter),
                      Icon(Icons.directions_walk),
                      Icon(Icons.train)
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
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                  JobActiveScreen.routeName,
                  arguments: currentJob);
              print('job selected');
            },
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      // Colors.yellow,
                      // Colors.green,
                      Palette.bToDark,
                      Palette.kToDark
                    ]),
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
  }
}
