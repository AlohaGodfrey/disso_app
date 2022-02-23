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

class JobListScreen extends StatefulWidget {
  static const routeName = '/sliver-job-list';

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  var _isLoading = true;
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
  void refreshPage() {
    setState(() {
      Provider.of<Jobs>(context, listen: false).fetchAndSetJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    jobList = Provider.of<Jobs>(context, listen: true).jobItems;
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
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.separated(
                        padding: const EdgeInsets.only(top: 24, bottom: 0),
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
                    ),
            ]),
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
