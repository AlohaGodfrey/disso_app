import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/jobs.dart';
import '../widgets/list_job_card.dart';
import '../widgets/app_drawer.dart';

// class LegacyJobListScreen extends StatelessWidget {
//   static const routeName = '/list-jobs';

//   @override
//   Widget build(BuildContext context) {
//     final JobList = Provider.of<Jobs>(context).jobItems; //access the joblist
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Job List',
//         ),
//       ),
//       drawer: AppDrawer(),
//       body: ListView.separated(
//         padding: const EdgeInsets.symmetric(vertical: 24),
//         physics: const BouncingScrollPhysics(),
//         itemCount: JobList.length,
//         itemBuilder: (context, index) {
//           // return JobCard(
//           //   jobInstance: JobList[index],
//           // );
//           // return JobCard(job: JobList[index]);
//         },
//         separatorBuilder: (context, index) {
//           return const SizedBox(
//             height: 12,
//           );
//         },
//       ),
//     );
//   }
// }
