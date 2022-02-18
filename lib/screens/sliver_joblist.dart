import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_sliver.dart';

import '../widgets/app_drawer.dart';
import '../providers/jobs.dart';
import '../widgets/job_card.dart';

class SliverJobList extends StatelessWidget {
  static const routeName = '/sliver-job-list';

  @override
  Widget build(BuildContext context) {
    final JobList = Provider.of<Jobs>(context).jobItems; //access the joblist
    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text('Job List'),
          ),
          ProfileSliver(),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 24, bottom: 0),
                  // physics: const BouncingScrollPhysics(),
                  physics: const ClampingScrollPhysics(),

                  itemCount: JobList.length,
                  itemBuilder: (context, index) {
                    return JobCard(
                      jobInstance: JobList[index],
                    );
                    // return JobCard(job: JobList[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 12,
                    );
                  },
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
