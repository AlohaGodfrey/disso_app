import 'package:disso_app/models/place_location.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';

// import '../providers/jobs.dart';
import '../providers/jobs_firebase.dart';
import '../models/job_model.dart';
import '../theme/palette.dart';
import './details_job_widgets.dart';

class EditJobForm extends StatefulWidget {
  final GlobalKey<FormState> form;
  final String? jobId;
  final Function updateJobDetails;
  const EditJobForm(
      {required this.form,
      required this.jobId,
      required this.updateJobDetails,
      Key? key})
      : super(key: key);

  @override
  _EditJobFormState createState() => _EditJobFormState();
}

class _EditJobFormState extends State<EditJobForm> {
  final _postCodeFocusNode = FocusNode();
  DateTime? _selectedDate;
  var _editedJob = Job(
      id: '',
      title: '',
      description: '',
      endDate: DateTime.now(),
      postcode: '');

  var _initValues = {
    'title': '',
    'description': '',
  };

  var _isInit = true;

  void _presentDatePicker() {
    //pick job date up to a month in advance
    showDatePicker(
            context: context,
            initialDate: _initValues['endDate'] == null
                ? DateTime.now()
                : _editedJob.endDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1,
                DateTime.now().day))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
      //updates edit_job_scren Job Object
      widget.updateJobDetails(
        Job(
          id: _editedJob.id,
          title: _editedJob.title,
          description: _editedJob.description,
          postcode: _editedJob.postcode,
          payRate: _editedJob.payRate,
          endDate: _selectedDate as DateTime,
          vehicleRequired: _editedJob.vehicleRequired,
          lightConfig: _editedJob.lightConfig,
          location: _editedJob.location,
        ),
      );
      //updates local job object
      _editedJob = Job(
        id: _editedJob.id,
        title: _editedJob.title,
        description: _editedJob.description,
        postcode: _editedJob.postcode,
        payRate: _editedJob.payRate,
        endDate: _selectedDate as DateTime,
        vehicleRequired: _editedJob.vehicleRequired,
        lightConfig: _editedJob.lightConfig,
        location: _editedJob.location,
      );
    });
  }

  @override
  void didChangeDependencies() {
    //didChange...() is a in built function used for state managemet
    //developers can overivde these functions so code is executed
    //at different time.

    //didChangeDepe...() runs multiple times. we want the code to
    //execute when the variable _isIniti is initialised. so the
    //arguments are loaded into the properties at the right time.

    //once the _isInit if statment is run. _isInit is set to false.
    //and can never be changed back to true.

    //If Job id is valid, copy the old data into the form to be edited.
    //else create new empty fields for the form
    if (_isInit) {
      if (widget.jobId != null) {
        _editedJob = Provider.of<JobsFirebase>(context, listen: false)
            .findById(widget.jobId as String);

        _initValues = {
          'title': _editedJob.title,
          'description': _editedJob.description,
          'payRate': _editedJob.payRate.toString(),
          'endDate': _editedJob.endDate.toString(),
          'postcode': _editedJob.postcode
        };
        _selectedDate = _editedJob.endDate;
      }
    }
    _isInit = false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.form,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: googleFontStyle('Job Details'),
          ),
          Container(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No Date Chosen!'
                        : 'Picked Date: ${DateFormat.yMd().format(_selectedDate as DateTime)}',
                  ),
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  onPressed: _presentDatePicker,
                  child: const Text(
                    'Choose Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),

          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              initialValue: _initValues['title'],
              decoration: const InputDecoration(
                  labelText: 'Site Area', border: OutlineInputBorder()),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_postCodeFocusNode);
              },
              validator: (value) {
                if (value == null) {
                  return 'return is null';
                } else if (value.isEmpty) {
                  return 'Please provide a Title.';
                }
                return null;
              },
              onSaved: (value) {
                widget.updateJobDetails(
                  Job(
                    id: _editedJob.id,
                    title: value as String,
                    description: _editedJob.description,
                    postcode: _editedJob.postcode,
                    payRate: _editedJob.payRate,
                    endDate: _editedJob.endDate,
                    vehicleRequired: _editedJob.vehicleRequired,
                    lightConfig: _editedJob.lightConfig,
                    location: _editedJob.location,
                  ),
                );

                _editedJob = Job(
                  id: _editedJob.id,
                  title: value as String,
                  description: _editedJob.description,
                  postcode: _editedJob.postcode,
                  payRate: _editedJob.payRate,
                  endDate: _editedJob.endDate,
                  vehicleRequired: _editedJob.vehicleRequired,
                  lightConfig: _editedJob.lightConfig,
                  location: _editedJob.location,
                );
              },
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              initialValue: _initValues['postcode'],
              decoration: const InputDecoration(
                  labelText: 'PostCode', border: OutlineInputBorder()),
              textInputAction: TextInputAction.next,
              focusNode: _postCodeFocusNode,
              validator: (value) {
                if (value == null) {
                  return 'return is null';
                } else if (value.isEmpty) {
                  return 'Please provide an Area Postcode';
                }
                if (value.length < 5) {
                  return 'Should be at least five characters long';
                }
                if (value.length > 8) {
                  return 'Postcode should be 5-8 characters long';
                }

                return null;
              },
              onSaved: (value) async {
                // updates state job
                widget.updateJobDetails(
                  Job(
                    id: _editedJob.id,
                    title: _editedJob.title,
                    description: _editedJob.description == ''
                        ? 'Two Way Lights \u{1F6A6}\u{1F6A6}'
                        : _editedJob.description,
                    postcode: value!.toUpperCase(),
                    payRate: _editedJob.payRate,
                    endDate: _editedJob.endDate,
                    vehicleRequired: _editedJob.vehicleRequired,
                    lightConfig: _editedJob.lightConfig,
                    // location: PlaceLocation(latitude: lat, longitude: lng),
                  ),
                  // updates local job
                );
                _editedJob = Job(
                  id: _editedJob.id,
                  title: _editedJob.title,
                  description: _editedJob.description == ''
                      ? 'Two Way Lights \u{1F6A6}\u{1F6A6}'
                      : _editedJob.description,
                  postcode: value.toUpperCase(),
                  payRate: _editedJob.payRate,
                  endDate: _editedJob.endDate,
                  vehicleRequired: _editedJob.vehicleRequired,
                  lightConfig: _editedJob.lightConfig,
                  // location: PlaceLocation(latitude: lat, longitude: lng),
                );
              },
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              initialValue: '13.50',
              decoration: const InputDecoration(
                  labelText: 'Pay Rate [£13.50]', border: OutlineInputBorder()),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onSaved: (value) {
                widget.updateJobDetails(
                  Job(
                    id: _editedJob.id,
                    title: _editedJob.title,
                    description: _editedJob.description,
                    postcode: _editedJob.postcode,
                    payRate: double.parse(value as String),
                    vehicleRequired: _editedJob.vehicleRequired,
                    lightConfig: _editedJob.lightConfig,
                    endDate: _editedJob.endDate,
                    location: _editedJob.location,
                  ),
                );

                _editedJob = Job(
                  id: _editedJob.id,
                  title: _editedJob.title,
                  description: _editedJob.description,
                  postcode: _editedJob.postcode,
                  payRate: double.parse(value as String),
                  vehicleRequired: _editedJob.vehicleRequired,
                  lightConfig: _editedJob.lightConfig,
                  endDate: _editedJob.endDate,
                  location: _editedJob.location,
                );
              },
              validator: (value) {
                if (value == null) {
                  return 'return is null';
                  //needed for null safety checks in flutter v1.12^
                }
                if (value.isEmpty) {
                  return 'Please enter a Price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number.';
                }
                if (double.parse(value) <= 0) {
                  return 'Please enter a number greater than zero.';
                }
                return null;
              },
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: googleFontStyle('Vehicle Requirements'),
          ),
          const Divider(),
          Align(
            alignment: Alignment.center,
            child: ToggleSwitch(
              minWidth: MediaQuery.of(context).size.width * 0.27,
              minHeight: 40,
              activeFgColor: Colors.white,
              totalSwitches: 3,
              labels: const ['None', 'Car Only', 'No Cars'],
              icons: const [
                IconData(0xe0de, fontFamily: 'MaterialIcons'),
                IconData(0xe208, fontFamily: 'MaterialIcons'),
                IconData(0xe0e1, fontFamily: 'MaterialIcons'),
              ],
              initialLabelIndex:
                  _editedJob.vehicleRequired == VehicleRequired.anyTransport
                      ? 0
                      : _editedJob.vehicleRequired == VehicleRequired.carOnly
                          ? 1
                          : 2,
              activeBgColors: const [
                [Palette.kToLight],
                [Palette.kToLight],
                [Palette.kToLight],
              ],
              cornerRadius: 20,
              onToggle: (index) {
                switch (index) {
                  case 0:
                    {
                      widget.updateJobDetails(
                        Job(
                          id: _editedJob.id,
                          title: _editedJob.title,
                          description: _editedJob.description,
                          postcode: _editedJob.postcode,
                          payRate: _editedJob.payRate,
                          vehicleRequired: VehicleRequired.anyTransport,
                          lightConfig: _editedJob.lightConfig,
                          endDate: _editedJob.endDate,
                          location: _editedJob.location,
                        ),
                      );
                      _editedJob = Job(
                        id: _editedJob.id,
                        title: _editedJob.title,
                        description: _editedJob.description,
                        postcode: _editedJob.postcode,
                        payRate: _editedJob.payRate,
                        vehicleRequired: VehicleRequired.anyTransport,
                        lightConfig: _editedJob.lightConfig,
                        endDate: _editedJob.endDate,
                        location: _editedJob.location,
                      );
                    }
                    break;
                  case 1:
                    {
                      widget.updateJobDetails(
                        Job(
                          id: _editedJob.id,
                          title: _editedJob.title,
                          description: _editedJob.description,
                          postcode: _editedJob.postcode,
                          payRate: _editedJob.payRate,
                          vehicleRequired: VehicleRequired.carOnly,
                          lightConfig: _editedJob.lightConfig,
                          endDate: _editedJob.endDate,
                          location: _editedJob.location,
                        ),
                      );
                      _editedJob = Job(
                        id: _editedJob.id,
                        title: _editedJob.title,
                        description: _editedJob.description,
                        postcode: _editedJob.postcode,
                        payRate: _editedJob.payRate,
                        vehicleRequired: VehicleRequired.carOnly,
                        lightConfig: _editedJob.lightConfig,
                        endDate: _editedJob.endDate,
                        location: _editedJob.location,
                      );
                    }
                    break;
                  case 2:
                    {
                      widget.updateJobDetails(
                        Job(
                          id: _editedJob.id,
                          title: _editedJob.title,
                          description: _editedJob.description,
                          postcode: _editedJob.postcode,
                          payRate: _editedJob.payRate,
                          vehicleRequired: VehicleRequired.noParking,
                          lightConfig: _editedJob.lightConfig,
                          endDate: _editedJob.endDate,
                          location: _editedJob.location,
                        ),
                      );
                      _editedJob = Job(
                        id: _editedJob.id,
                        title: _editedJob.title,
                        description: _editedJob.description,
                        postcode: _editedJob.postcode,
                        payRate: _editedJob.payRate,
                        vehicleRequired: VehicleRequired.noParking,
                        lightConfig: _editedJob.lightConfig,
                        endDate: _editedJob.endDate,
                        location: _editedJob.location,
                      );
                    }
                    break;
                  default:
                    return;
                }
              },
            ),
          ),
          //site config switch
          //vehicle required bool switch
          //date selector
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: googleFontStyle(
                '\u{1F6A6}\u{1F6A6}\u{1F6A6}  Light Configuration   \u{1F6A6}\u{1F6A6}\u{1F6A6}'),
          ),
          const Divider(),

          Align(
            alignment: Alignment.center,
            child: ToggleSwitch(
              minWidth: MediaQuery.of(context).size.width * 0.27,
              minHeight: 40,
              activeFgColor: Colors.white,
              totalSwitches: 3,
              labels: const ['Two-Way', 'Three-Way', 'Four-Way'],
              initialLabelIndex: _editedJob.lightConfig == LightConfig.twoWay
                  ? 0
                  : _editedJob.lightConfig == LightConfig.threeWay
                      ? 1
                      : 2,
              activeBgColors: const [
                [Colors.green],
                [Colors.orange],
                [Colors.red]
              ],
              cornerRadius: 20,
              onToggle: (index) {
                switch (index) {
                  case 0:
                    {
                      widget.updateJobDetails(
                        Job(
                          id: _editedJob.id,
                          title: _editedJob.title,
                          description: 'Two Way Lights \u{1F6A6}\u{1F6A6}',
                          postcode: _editedJob.postcode,
                          payRate: _editedJob.payRate,
                          vehicleRequired: _editedJob.vehicleRequired,
                          lightConfig: _editedJob.lightConfig,
                          endDate: _editedJob.endDate,
                          location: _editedJob.location,
                        ),
                      );
                      _editedJob = Job(
                        id: _editedJob.id,
                        title: _editedJob.title,
                        description: 'Two Way Lights \u{1F6A6}\u{1F6A6}',
                        postcode: _editedJob.postcode,
                        payRate: _editedJob.payRate,
                        vehicleRequired: _editedJob.vehicleRequired,
                        lightConfig: LightConfig.twoWay,
                        endDate: _editedJob.endDate,
                        location: _editedJob.location,
                      );
                    }
                    break;
                  case 1:
                    {
                      widget.updateJobDetails(
                        Job(
                          id: _editedJob.id,
                          title: _editedJob.title,
                          description:
                              'Three Way Lights \u{1F6A6}\u{1F6A6}\u{1F6A6}',
                          postcode: _editedJob.postcode,
                          payRate: _editedJob.payRate,
                          vehicleRequired: _editedJob.vehicleRequired,
                          lightConfig: _editedJob.lightConfig,
                          endDate: _editedJob.endDate,
                          location: _editedJob.location,
                        ),
                      );
                      _editedJob = Job(
                        id: _editedJob.id,
                        title: _editedJob.title,
                        description:
                            'Three Way Lights \u{1F6A6}\u{1F6A6}\u{1F6A6}',
                        postcode: _editedJob.postcode,
                        payRate: _editedJob.payRate,
                        vehicleRequired: _editedJob.vehicleRequired,
                        lightConfig: LightConfig.threeWay,
                        endDate: _editedJob.endDate,
                        location: _editedJob.location,
                      );
                    }
                    break;
                  case 2:
                    {
                      widget.updateJobDetails(
                        Job(
                          id: _editedJob.id,
                          title: _editedJob.title,
                          description:
                              'Four Way Lights \u{1F6A6}\u{1F6A6}\u{1F6A6}\u{1F6A6}',
                          postcode: _editedJob.postcode,
                          payRate: _editedJob.payRate,
                          vehicleRequired: _editedJob.vehicleRequired,
                          lightConfig: _editedJob.lightConfig,
                          endDate: _editedJob.endDate,
                          location: _editedJob.location,
                        ),
                      );
                      _editedJob = Job(
                        id: _editedJob.id,
                        title: _editedJob.title,
                        description:
                            'Four Way Lights \u{1F6A6}\u{1F6A6}\u{1F6A6}\u{1F6A6}',
                        postcode: _editedJob.postcode,
                        payRate: _editedJob.payRate,
                        vehicleRequired: _editedJob.vehicleRequired,
                        lightConfig: LightConfig.fourWay,
                        endDate: _editedJob.endDate,
                        location: _editedJob.location,
                      );
                    }
                    break;
                  default:
                    {
                      widget.updateJobDetails(
                        Job(
                          id: _editedJob.id,
                          title: _editedJob.title,
                          description: 'Two Way Lights \u{1F6A6}\u{1F6A6}',
                          postcode: _editedJob.postcode,
                          payRate: _editedJob.payRate,
                          vehicleRequired: _editedJob.vehicleRequired,
                          lightConfig: _editedJob.lightConfig,
                          endDate: _editedJob.endDate,
                          location: _editedJob.location,
                        ),
                      );
                      _editedJob = Job(
                        id: _editedJob.id,
                        title: _editedJob.title,
                        description: 'Two Way Lights \u{1F6A6}\u{1F6A6}',
                        postcode: _editedJob.postcode,
                        payRate: _editedJob.payRate,
                        vehicleRequired: _editedJob.vehicleRequired,
                        lightConfig: LightConfig.twoWay,
                        endDate: _editedJob.endDate,
                        location: _editedJob.location,
                      );

                      _editedJob.lightConfig.index;
                    }
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
