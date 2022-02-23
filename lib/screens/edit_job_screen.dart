import 'package:disso_app/screens/job_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_sliver.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../providers/jobs.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../legacy_screens/legacy_new_job_form.dart';
import '../models/job_model.dart';
import '../theme/palette.dart';
import '../widgets/job_details_text.dart';
import '../widgets/edit_job_form.dart';

class EditJobScreen extends StatefulWidget {
  static const routeName = '/add-new-jobs';

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

    setState(() {
      _isLoading = true;
    });

    if (_editedJob.id != '') {
      await Provider.of<Jobs>(context, listen: false)
          .updateJob(_editedJob.id, _editedJob);
    } else {
      try {
        //pushes object to global products
        await Provider.of<Jobs>(context, listen: false).addJob(_editedJob);
        // //force all app listners to update
        // await Provider.of<Jobs>(context, listen: false).fetchAndSetJobs();
      } catch (error) {
        await showDialog<void>(
          //add custom dialog
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'),
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
    Navigator.of(context).pushReplacementNamed(JobListScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // final jobList = Provider.of<Jobs>(context).jobItems; //access the joblist
    final isAdmin = Provider.of<Auth>(context).isAdmin; //checks isAdmin?
    final jobId = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      // drawer: const AppDrawer(),
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('New Job Edit'),
            actions: [
              IconButton(
                onPressed: () {
                  _saveForm();
                  Navigator.of(context).pop;
                },
                icon: Icon(Icons.save),
                color: Palette.bToDark,
              ),
            ],
          ),
          ProfileSliver(isAdmin: isAdmin),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: (MediaQuery.of(context).size.height / 7) * 4.5,
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
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
                    jobId: jobId as String?,
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
