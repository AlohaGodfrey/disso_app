import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/Job.dart';
import '../screens/job_detail_screen.dart';

class JobCard extends StatelessWidget {
  final Job jobInstance;

  JobCard({required this.jobInstance});

  @override
  Widget build(BuildContext context) {
    final jobTitle = jobInstance.title;
    final jobDesc = jobInstance.description;

    return GestureDetector(
      onTap: () {
        print('clicked');
        print(jobInstance.id);
        Navigator.of(context)
            .pushNamed(JobDetailScreen.routeName, arguments: jobInstance);
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
                children: [
                  // SizedBox(height: 10),
                  //get rid of const
                  //title
                  Text(jobTitle,
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  //subtitle
                  Text('System | $jobDesc',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800)),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Transportation',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 13,
                        ),
                      ),
                      Text('|'),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 6),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6)),
                          child: Icon(Icons.train)),
                      Icon(Icons.drive_eta),
                      Icon(Icons.directions_walk),
                      // Icon(Icons.train),
                      Icon(Icons.bike_scooter),
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
