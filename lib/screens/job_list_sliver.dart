import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_sliver.dart';

import '../providers/jobs.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../widgets/job_card.dart';

class SliverJobList extends StatelessWidget {
  static const routeName = '/sliver-job-list';

  @override
  Widget build(BuildContext context) {
    final jobList = Provider.of<Jobs>(context).jobItems; //access the joblist
    final isAdmin = Provider.of<Auth>(context).isAdmin; //checks isAdmin?
    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text('Job List'),
          ),
          ProfileSliver(isAdmin: isAdmin),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 24, bottom: 0),
                  // physics: const BouncingScrollPhysics(),
                  physics: const ClampingScrollPhysics(),

                  itemCount: jobList.length,
                  itemBuilder: (context, index) {
                    return JobCard(
                      jobInstance: jobList[index],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
        visible: isAdmin,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    );
  }
}
