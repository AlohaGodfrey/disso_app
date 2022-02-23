import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../widgets/profile_sliver.dart';
import './edit_job_screen.dart';
import '../providers/jobs.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../widgets/job_card.dart';
import '../theme/palette.dart';
import '../models/job_model.dart';
import '../widgets/job_details_text.dart';

class JobListScreen extends StatefulWidget {
  static const routeName = '/sliver-job-list';

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  var _isLoading = true;
  var jobAvailability = false;
  late List<Job> jobList;

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

  //used to autorefresh page once and item is removed from jobs provider
  void refreshPage() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Jobs>(context, listen: false).clearJobList();
    await Provider.of<Jobs>(context, listen: false).fetchAndSetJobs();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    jobList = Provider.of<Jobs>(context, listen: true).jobItems;
    final isAdmin = Provider.of<Auth>(context).isAdmin; //checks isAdmin?
    jobAvailability = jobList.isNotEmpty;
    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Job List'),
            actions: [
              IconButton(
                onPressed: refreshPage,
                icon: Icon(Icons.refresh),
              ),
            ],
          ),
          ProfileSliver(isAdmin: isAdmin),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _isLoading
                    ? Container(
                        height: (MediaQuery.of(context).size.height / 7) * 4.5,
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        margin: const EdgeInsets.all(12),
                        child: Center(
                          child: LoadingAnimationWidget.inkDrop(
                              color: Palette.bToLight, size: 25),
                        ),
                      )
                    : jobAvailability
                        ? Container(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.only(top: 24, bottom: 0),
                              // physics: const BouncingScrollPhysics(),
                              physics: const ClampingScrollPhysics(),
                              // physics: NeverScrollableScrollPhysics(),

                              itemCount: jobList.length,
                              itemBuilder: (context, index) {
                                return JobCard(
                                  jobInstance: jobList[index],
                                  refreshPage: refreshPage,
                                );
                                // return JobCard(job: JobList[index]);
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 12,
                                );
                              },
                            ),
                          )
                        : Container(
                            height: 100,
                            padding: const EdgeInsets.all(12),
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(136, 212, 212, 212),
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0,
                                        2.0), // shadow direction: bottom right
                                  ),
                                ]),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  googleFontStyle('Connected'),
                                  googleFontStyle('No jobs Available'),
                                  googleFontStyle('Contact your Supervisor'),
                                ],
                              ),
                            ),
                          ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
        visible: isAdmin,
        child: FloatingActionButton(
          backgroundColor: Palette.kToDark.shade100,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(EditJobScreen.routeName);
          },
        ),
      ),
    );
  }
}
