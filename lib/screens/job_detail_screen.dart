import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; //format date
import 'package:cool_alert/cool_alert.dart';

import '../models/job_model.dart';
import '../widgets/job_details_text.dart';
import '../widgets/location_input.dart';
import '../helpers/location_helper.dart';
import '../theme/palette.dart';
import '../screens/job_active_screen.dart';
import '../providers/auth.dart';
import '../providers/Jobs.dart';
import 'edit_job_screen.dart';

class JobDetailScreen extends StatelessWidget {
  static const routeName = '/job-detail';
  bool jobDelete = false;
  // JobDetailScreen({this.isAdmin = false});

  //get the job id to enter the data before sending it to be rendered

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<Auth>(context).isAdmin; //checks isAdmin?
    final Job currentJob = ModalRoute.of(context)!.settings.arguments as Job;

    // Provider.of<Jobs>(context, listen: false).fetchAndSetJobs();
    final _previewImageUrl = LocationHelper.generateLocationPreviewImage(
        latitute: currentJob.location.latitude,
        longitude: currentJob.location.longitude);

    return ChangeNotifierProxyProvider<Auth, Jobs>(
      create: (context) => Jobs([
        Job(
          id: 'p1',
          title: 'Islington',
          description: 'Two way lights',
          endDate: DateTime.now(),
          postcode: 'HP11 2et',
        ),
      ], authToken: '', authUserId: ''),
      update: (ctx, auth, previousJobs) {
        return Jobs(previousJobs == null ? [] : previousJobs.jobItems,
            authToken: auth.token == null ? '' : auth.token as String,
            authUserId: auth.userId == null ? '' : auth.userId as String);
      },
      builder: (context, child) {
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
                    CoolAlert.show(
                      context: context,
                      title: 'Delete Job Entry?',
                      text: 'This action cannot be undone',
                      type: CoolAlertType.confirm,
                      confirmBtnText: 'Delete Job',
                      confirmBtnColor: Colors.red,
                      backgroundColor: Palette.kToLight,
                      onConfirmBtnTap: () async {
                        //signals the main list to refresh
                        jobDelete = true;
                        //delete the item
                        await Provider.of<Jobs>(context, listen: false)
                            .fetchAndSetJobs();
                        await Provider.of<Jobs>(context, listen: false)
                            .deleteJob(currentJob.id);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(jobDelete);
                      },
                    );
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
                    Navigator.of(context).pushNamed(EditJobScreen.routeName,
                        arguments: currentJob.id);
                  },
                  icon: Icon(Icons.edit),
                ),
              )
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              jobDetailPanel(currentJob),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  // height: 265,
                  height: MediaQuery.of(context).size.height * 0.3,
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
                          offset: Offset(
                              2.0, 2.0), // shadow direction: bottom right
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
                height: 3,
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
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
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
      },
    );
  }
}
