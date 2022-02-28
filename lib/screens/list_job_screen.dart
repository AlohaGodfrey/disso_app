import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../routes/routes.dart';
import '../widgets/profile_search_sliver.dart';
import './edit_job_screen.dart';
import '../providers/jobs.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../widgets/list_job_card.dart';
import '../theme/palette.dart';
import '../models/job_model.dart';
import '../widgets/details_job_text.dart';

class ListJobScreen extends StatefulWidget {
  static const routeName = '/sliver-job-list';

  @override
  State<ListJobScreen> createState() => _ListJobScreenState();
}

class _ListJobScreenState extends State<ListJobScreen> {
  var _isLoading = true;
  var jobAvailability = false;
  late List<Job> jobList;
  List<Job> jobListSearch = [];
  TextEditingController _searchController = TextEditingController();

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUpdateJobList(String value) async {
    setState(() {
      jobListSearch = jobList
          .where((jobInstance) =>
              jobInstance.title.toLowerCase().contains(value.toLowerCase()))
          .toList();

      if (_searchController.text.isNotEmpty && jobListSearch.isEmpty) {
        // print('Job list search length: ${jobListSearch.length}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    jobList = Provider.of<Jobs>(context, listen: true).jobItems;
    final isAdmin = Provider.of<Auth>(context).isAdmin; //checks isAdmin?
    jobAvailability = jobList.isNotEmpty;
    final deviceSize = MediaQuery.of(context).size;

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
          ProfileSearchSliver(
            isAdmin: isAdmin,
            searchController: _searchController,
            searchFunction: _searchUpdateJobList,
            searchBarHint: "Enter a Job Site?",
            searchType: SearchType.viaTextInput,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _isLoading
                    //showws loading spinner
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
                            //shows job list
                            height: MediaQuery.of(context).size.height,
                            child: _searchController.text.isNotEmpty &&
                                    jobListSearch.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.all(12)),
                                        Icon(
                                          Icons.search_off,
                                          size: 100,
                                          color: Palette.kToLight,
                                        ),
                                        Text('No results found',
                                            style: GoogleFonts.inter(
                                                fontSize: 35,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey.shade800))
                                      ],
                                    ),
                                  )
                                : ListView.separated(
                                    padding: const EdgeInsets.only(
                                        top: 24, bottom: 0),
                                    // physics: const BouncingScrollPhysics(),
                                    physics: const ClampingScrollPhysics(),
                                    // physics: NeverScrollableScrollPhysics(),

                                    itemCount: _searchController.text.isNotEmpty
                                        ? jobListSearch.length
                                        : jobList.length,
                                    itemBuilder: (context, index) {
                                      return JobCard(
                                        jobInstance:
                                            _searchController.text.isNotEmpty
                                                ? jobListSearch[index]
                                                : jobList[index],
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
                            //shows inital no jobs available on firebase
                            // height: 100,
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
        visible: true,
        child: FloatingActionButton(
          backgroundColor: Palette.kToDark.shade100,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(RouteManager.editJobScreen);
          },
        ),
      ),
    );
  }
}
