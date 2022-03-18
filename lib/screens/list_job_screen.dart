import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../routes/routes.dart';
import '../theme/palette.dart';
import '../providers/jobs_firebase.dart';
import '../providers/auth.dart';
import '../models/job_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/show_dialog.dart';
import '../widgets/list_job_card.dart';
import '../widgets/details_job_widgets.dart';
import '../widgets/profile_search_sliver.dart';

class ListJobScreen extends StatefulWidget {
  const ListJobScreen({Key? key}) : super(key: key);

  @override
  State<ListJobScreen> createState() => _ListJobScreenState();
}

class _ListJobScreenState extends State<ListJobScreen> {
  var _isLoading = true;
  var jobAvailability = false;
  //store online Jobs List
  late List<Job> jobList;
  //store Jobs Queried
  List<Job> jobListSearch = [];
  //search textfield controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //loading spinner while loading Jobs from database
    setState(() {
      _isLoading = true;
    });
    Provider.of<JobsFirebase>(context, listen: false)
        .fetchAndSetJobs()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  //used to autorefresh page once and item is removed from jobs provider
  Future<void> refreshPage() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<JobsFirebase>(context, listen: false).clearJobList();
    await Provider.of<JobsFirebase>(context, listen: false).fetchAndSetJobs();

    setState(() {
      _isLoading = false;
    });
  }

  //frees up memory by deleting search controller
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //queries the JobList using the search data entered
  Future<void> _searchUpdateJobList(String value) async {
    setState(() {
      jobListSearch = jobList
          .where((jobInstance) =>
              jobInstance.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    //uses Auth & Jobs Providers to retrieve relevant data
    jobList = Provider.of<JobsFirebase>(context, listen: true).jobItems;
    //if user isAdmin, enable 'add new job'
    final isAdmin = Provider.of<Auth>(context).isAdmin;
    //bool flag message if no job objects returned from search query
    jobAvailability = jobList.isNotEmpty;
    //gets the device size
    var deviceSize = MediaQuery.of(context).size;
    bool isLargeScreen = deviceSize.width > Palette.deviceScreenThreshold;
    return Scaffold(
      drawer: const AppDrawer(
        key: Key('ListAppDrawer'),
      ),
      body: RefreshIndicator(
        onRefresh: refreshPage,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: const Text(
                'Job List',
                key: Key('JobListTitle'),
              ),
              actions: [
                IconButton(
                  key: const Key('refreshJobListIcon'),
                  onPressed: refreshPage,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            ProfileSearchSliver(
              isAdmin: isAdmin,
              searchController: _searchController,
              searchFunction: _searchUpdateJobList,
              searchBarHint: "Enter a Job Site?",
              searchType: SearchType.viaTextInput,
              helpDialog: HelpHintType.listUser,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _isLoading
                      //showws loading spinner
                      ? Container(
                          height:
                              (MediaQuery.of(context).size.height / 7) * 4.5,
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          margin: const EdgeInsets.all(12),
                          child: Center(
                            child: LoadingAnimationWidget.inkDrop(
                                key: const Key('ListJobLoadingAnimation'),
                                color: Palette.bToLight,
                                size: 25),
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
                                          const Padding(
                                              padding: EdgeInsets.all(12)),
                                          const Icon(Icons.search_off,
                                              size: 100,
                                              color: Palette.kToLight),
                                          Text('No results found',
                                              style: GoogleFonts.inter(
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade800))
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true, //preload all list items
                                      padding: isLargeScreen
                                          ? EdgeInsets.only(
                                              top: 24,
                                              bottom: 0,
                                              left: deviceSize.width * 0.2,
                                              right: deviceSize.width * 0.2,
                                            )
                                          : const EdgeInsets.only(
                                              top: 24,
                                              bottom: 0,
                                            ),
                                      //enable ListView scrolling on web platform
                                      physics: kIsWeb
                                          ? const ClampingScrollPhysics()
                                          : const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          _searchController.text.isNotEmpty
                                              ? jobListSearch.length
                                              : jobList.length,
                                      itemBuilder: (context, index) {
                                        return JobCard(
                                          key: const Key('SingleJobCard'),
                                          jobInstance:
                                              _searchController.text.isNotEmpty
                                                  ? jobListSearch[index]
                                                  : jobList[index],
                                          refreshJobList: refreshPage,
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 12,
                                        );
                                      },
                                    ),
                            )
                          : Container(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
        visible: isAdmin,
        child: FloatingActionButton(
          backgroundColor: Palette.kToDark.shade100,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(RouteManager.editJobScreen);
          },
        ),
      ),
    );
  }
}
