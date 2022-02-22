import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../widgets/profile_sliver.dart';
import '../screens/new_job_screen.dart';
import '../providers/jobs.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../widgets/job_card.dart';

class JobListScreen extends StatefulWidget {
  static const routeName = '/sliver-job-list';

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  var _isLoading = false;

  @override
  void initState() {
    //loading spinner decider
    setState(() {
      _isLoading = true;
    });

    Provider.of<Jobs>(context, listen: false).fetchAndSetJobs().then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final jobList = Provider.of<Jobs>(context).jobItems; //access the joblist
    // force admin true for debugging !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // ProfileSliver(isAdmin: isAdmin),
    // final isAdmin = true;
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
          onPressed: () {
            Navigator.of(context)..pushNamed(NewJobScreen.routeName);
          },
        ),
      ),
    );
  }
}
