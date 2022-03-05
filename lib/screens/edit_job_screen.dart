import 'package:disso_app/models/place_location.dart';
import 'package:disso_app/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/routes.dart';
import '../theme/palette.dart';

// import '../providers/jobs.dart';
import '../providers/jobs_firebase.dart';

import '../providers/auth.dart';
import '../models/job_model.dart';
import '../widgets/profile_sliver.dart';
import '../widgets/edit_job_card.dart';
import '../helpers/location_service.dart';

class EditJobScreen extends StatefulWidget {
  static const routeName = '/add-new-jobs';
  String? jobId;
  EditJobScreen({Key? key, required this.jobId}) : super(key: key);

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _form = GlobalKey<FormState>();

  var _editedJob = Job(
      id: '',
      title: '',
      description: '',
      endDate: DateTime.now(),
      postcode: '');

  //for loading spinner during upload
  // ignore: unused_field
  var _isLoading = false;

  void _updateJobDetails(Job revisedJob) {
    _editedJob = revisedJob;
  }

  //add date,veh,light config to final edit.
  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();

    if (isValid == null) {
      return;
    } else if (!isValid) {
      return;
    }

    //saves the user data
    _form.currentState?.save();

    //map api get valid data
    final place = await LocationService.getPlace(_editedJob.postcode as String);
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    //saves location to job
    _updateJobDetails(
      Job(
        id: _editedJob.id,
        title: _editedJob.title,
        description: _editedJob.description,
        postcode: _editedJob.postcode,
        payRate: _editedJob.payRate,
        endDate: _editedJob.endDate,
        vehicleRequired: _editedJob.vehicleRequired,
        lightConfig: _editedJob.lightConfig,
        location: PlaceLocation(latitude: lat, longitude: lng),
      ),
    );

    setState(() {
      _isLoading = true;
    });

    if (_editedJob.id != '') {
      await Provider.of<JobsFirebase>(context, listen: false)
          .updateJob(_editedJob.id, _editedJob);
    } else {
      try {
        //pushes object to global products
        await Provider.of<JobsFirebase>(context, listen: false)
            .addJob(_editedJob);
        // //force all app listners to update
        // await Provider.of<Jobs>(context, listen: false).fetchAndSetJobs();
      } catch (error) {
        await showDialog<void>(
          //add custom dialog
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed(RouteManager.listJobScreen);
  }

  @override
  Widget build(BuildContext context) {
    // final jobList = Provider.of<Jobs>(context).jobItems; //access the joblist
    final isAdmin = Provider.of<Auth>(context).isAdmin; //checks isAdmin?
    // final jobId = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      // drawer: const AppDrawer(),
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('New Job Edit'),
            actions: [
              IconButton(
                onPressed: () {
                  _saveForm();
                  Navigator.of(context).pop;
                },
                icon: const Icon(Icons.save),
                color: Palette.bToDark,
              ),
            ],
          ),
          ProfileSliver(
            isAdmin: isAdmin,
            helpDialog: HelpHintType.editJob,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: (MediaQuery.of(context).size.height / 7) * 4.5,
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.5
                      : double.infinity,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(136, 212, 212, 212),
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              2.0, 2.0), // shadow direction: bottom right
                        ),
                      ]),
                  child: EditJobForm(
                    form: _form,
                    jobId: widget.jobId,
                    updateJobDetails: _updateJobDetails,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
