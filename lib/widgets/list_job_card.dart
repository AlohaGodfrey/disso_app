import 'package:disso_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/job_model.dart';
import './details_job_widgets.dart';

class JobCard extends StatelessWidget {
  final Job jobInstance;
  final Function refreshPage;
  const JobCard(
      {required this.jobInstance, required this.refreshPage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final jobTitle = jobInstance.title;
    final jobDesc = jobInstance.description;
    return GestureDetector(
      onTap: () async {
        //closes the keyboard before moving screen.
        //fixes renderflexoverflowed bug
        FocusManager.instance.primaryFocus?.unfocus();
        await Future.delayed(const Duration(milliseconds: 70), () {});

        //pushes the Detail Jobscreen and pass the instance of the job selected,
        //returns deleteObject from Edit screen if selected
        final _confirmDeleteJob = await Navigator.of(context)
            .pushNamed(RouteManager.detailJobScreen, arguments: jobInstance);

        //if EditScreen deleted selected the page is refreshed
        if (_confirmDeleteJob == true) {
          refreshPage();
        }
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(136, 212, 212, 212),
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset('assets/logo.png'),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    jobTitle,
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    jobDesc,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: transportIconFinder(jobInstance.vehicleRequired),
                      ),
                      googleFontStyle(' | '),
                      transportInfo(jobInstance.vehicleRequired),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
