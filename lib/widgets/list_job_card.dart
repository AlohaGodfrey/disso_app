import 'package:disso_app/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/Jobs.dart';
import '../models/job_model.dart';
import '../screens/detail_job_screen.dart';
import 'details_job_text.dart';

class JobCard extends StatelessWidget {
  final Job jobInstance;
  final Function refreshPage;

  JobCard({required this.jobInstance, required this.refreshPage});

  @override
  Widget build(BuildContext context) {
    final jobTitle = jobInstance.title;
    final jobDesc = jobInstance.description;
    // print(jobInstance.lightConfig);
    return GestureDetector(
      onTap: () async {
        // print(context.read<Jobs?>()!.authToken);

        final _confirmDeleteJob = await Navigator.of(context)
            .pushNamed(RouteManager.detailJobScreen, arguments: jobInstance);
        if (_confirmDeleteJob == true) {
          // Provider.of<Jobs>(context, listen: false).deleteJob(jobInstance.id);

          refreshPage();
          print('$_confirmDeleteJob');
        }
      },
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
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
        child: Row(
          children: [
            //display image
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12)),
                child: Image.asset('assets/logo.png'),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            //display job info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // SizedBox(height: 10),
                  //get rid of const
                  //title
                  Text(jobTitle,
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  //subtitle
                  Text('$jobDesc',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800)),

                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 6),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6)),
                          child:
                              transportIconFinder(jobInstance.vehicleRequired)),
                      googleFontStyle(' | '),
                      transportInfo(jobInstance.vehicleRequired),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
