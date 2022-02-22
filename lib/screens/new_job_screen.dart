import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_sliver.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/jobs.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../widgets/new_job_form.dart';
import '../models/Job.dart';
import '../theme/palette.dart';
import '../widgets/job_details_text.dart';

class NewJobScreen extends StatefulWidget {
  static const routeName = '/add-new-jobs';

  @override
  State<NewJobScreen> createState() => _NewJobScreenState();
}

class _NewJobScreenState extends State<NewJobScreen> {
  // const NewJobForm({Key? key}) : super(key: key);
  final _postCodeFocusNode = FocusNode();
  final _payRateFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
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

  //for loading spinner during upload
  var _isLoading = false;
  var _isInit = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //gets rid of listeneres to free up memory
    _payRateFocusNode.dispose();
    _postCodeFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    //didChange...() is a in built function used for state managemet
    //developers can overivde these functions so code is executed
    //at different time.

    //didChangeDepe...() runs multiple times. we want the code to
    //execute when the variable _isIniti is initialised. so the
    //arguments are loaded into the properties at the right time.

    //once the _isInit if statment is run. _isInit is set to false.
    //and can never be changed back to true.
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        // _editedJob = Provider.of<Jobs>(context, listen: false)
        //     .findById(productId as String);
        _initValues = {
          'title': _editedJob.title,
          'description': _editedJob.description,
          'payRate': _editedJob.payRate.toString(),
          'endDate': _editedJob.endDate.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _presentDatePicker() {
    //pick jobs a month in advance
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
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
    });
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
      } catch (error) {
        await showDialog<void>(
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
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final jobList = Provider.of<Jobs>(context).jobItems; //access the joblist
    final isAdmin = Provider.of<Auth>(context).isAdmin; //checks isAdmin?
    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('New Job Entry'),
            actions: [
              IconButton(
                onPressed: () {
                  _saveForm();
                },
                icon: Icon(Icons.save),
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.save),
              // ),
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
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: googleFontStyle('Job Details'),
                          ),
                          TextFormField(
                            initialValue: _initValues['title'],
                            decoration:
                                const InputDecoration(labelText: 'Site Area'),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_postCodeFocusNode);
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
                              _editedJob = Job(
                                id: _editedJob.id,
                                title: value as String,
                                description: _editedJob.description,
                                postcode: _editedJob.postcode,
                                payRate: _editedJob.payRate,
                                endDate: _editedJob.endDate,
                                vehicleRequired: _editedJob.vehicleRequired,
                                lightConfig: _editedJob.lightConfig,
                              );
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues['postcode'],
                            decoration:
                                const InputDecoration(labelText: 'PostCode'),
                            textInputAction: TextInputAction.next,
                            focusNode: _postCodeFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_payRateFocusNode);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'return is null';
                              } else if (value.isEmpty) {
                                return 'Please provide an Area Postcode';
                              }
                              if (value.length != 5) {
                                return 'Should be five characters long';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedJob = Job(
                                id: _editedJob.id,
                                title: _editedJob.title,
                                description: _editedJob.description,
                                postcode: value!.toUpperCase(),
                                payRate: _editedJob.payRate,
                                endDate: _editedJob.endDate,
                                vehicleRequired: _editedJob.vehicleRequired,
                                lightConfig: _editedJob.lightConfig,
                              );
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues['payRate'],
                            decoration: const InputDecoration(
                                labelText: 'Pay Rate [£13.50]'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _payRateFocusNode,
                            // onFieldSubmitted: (_) {
                            //   FocusScope.of(context).requestFocus(_postCodeFocusNode);
                            // },
                            onSaved: (value) {
                              _editedJob = Job(
                                id: _editedJob.id,
                                title: _editedJob.title,
                                description: _editedJob.description,
                                postcode: _editedJob.postcode,
                                payRate: double.parse(value as String),
                                vehicleRequired: _editedJob.vehicleRequired,
                                lightConfig: _editedJob.lightConfig,
                                endDate: _editedJob.endDate,
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),

                          Align(
                            alignment: Alignment.topCenter,
                            child: googleFontStyle('Site Accessibility'),
                          ),
                          Divider(),
                          Align(
                            alignment: Alignment.center,
                            child: ToggleSwitch(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.40,
                              minHeight: 40,
                              activeFgColor: Colors.white,
                              totalSwitches: 2,
                              labels: const ['Any Transport', 'Car Only'],
                              icons: const [
                                IconData(0xe0de, fontFamily: 'MaterialIcons'),
                                IconData(0xe208, fontFamily: 'MaterialIcons'),
                              ],
                              initialLabelIndex:
                                  _editedJob.vehicleRequired ? 1 : 0,
                              activeBgColors: const [
                                [Palette.kToLight],
                                [Palette.kToLight],
                              ],
                              cornerRadius: 20,
                              onToggle: (index) {
                                switch (index) {
                                  case 0:
                                    {
                                      _editedJob = Job(
                                        id: _editedJob.id,
                                        title: _editedJob.title,
                                        description: _editedJob.description,
                                        postcode: _editedJob.postcode,
                                        payRate: _editedJob.payRate,
                                        vehicleRequired: false,
                                        lightConfig: _editedJob.lightConfig,
                                        endDate: _editedJob.endDate,
                                      );
                                    }
                                    break;
                                  case 1:
                                    {
                                      _editedJob = Job(
                                        id: _editedJob.id,
                                        title: _editedJob.title,
                                        description: _editedJob.description,
                                        postcode: _editedJob.postcode,
                                        payRate: _editedJob.payRate,
                                        vehicleRequired: true,
                                        lightConfig: _editedJob.lightConfig,
                                        endDate: _editedJob.endDate,
                                      );
                                    }
                                    break;
                                  default:
                                    {
                                      _editedJob = Job(
                                        id: _editedJob.id,
                                        title: _editedJob.title,
                                        description: _editedJob.description,
                                        postcode: _editedJob.postcode,
                                        payRate: _editedJob.payRate,
                                        vehicleRequired: false,
                                        lightConfig: _editedJob.lightConfig,
                                        endDate: _editedJob.endDate,
                                      );
                                    }
                                    break;
                                }
                              },
                            ),
                          ),
                          //site config switch
                          //vehicle required bool switch
                          //date selector
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: googleFontStyle(
                                '\u{1F6A6}\u{1F6A6}\u{1F6A6}  Light Configuration   \u{1F6A6}\u{1F6A6}\u{1F6A6}'),
                          ),
                          Divider(),

                          Align(
                            alignment: Alignment.center,
                            child: ToggleSwitch(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.27,
                              minHeight: 40,
                              activeFgColor: Colors.white,
                              totalSwitches: 3,
                              labels: const [
                                'Two-Way',
                                'Three-Way',
                                'Four-Way'
                              ],
                              // icons: const [
                              //   FontAwesomeIcons.utensils,
                              //   FontAwesomeIcons.play,
                              //   FontAwesomeIcons.home
                              // ],
                              initialLabelIndex:
                                  _editedJob.lightConfig == LightConfig.twoWay
                                      ? 0
                                      : _editedJob.lightConfig ==
                                              LightConfig.threeWay
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
                                      _editedJob = Job(
                                        id: _editedJob.id,
                                        title: _editedJob.title,
                                        description:
                                            'Two Way Lights \u{1F6A6}\u{1F6A6}',
                                        postcode: _editedJob.postcode,
                                        payRate: _editedJob.payRate,
                                        vehicleRequired:
                                            _editedJob.vehicleRequired,
                                        lightConfig: _editedJob.lightConfig,
                                        endDate: _editedJob.endDate,
                                      );
                                    }
                                    break;
                                  case 1:
                                    {
                                      _editedJob = Job(
                                        id: _editedJob.id,
                                        title: _editedJob.title,
                                        description:
                                            'Three Way Lights \u{1F6A6}\u{1F6A6}\u{1F6A6}',
                                        postcode: _editedJob.postcode,
                                        payRate: _editedJob.payRate,
                                        vehicleRequired:
                                            _editedJob.vehicleRequired,
                                        lightConfig: _editedJob.lightConfig,
                                        endDate: _editedJob.endDate,
                                      );
                                    }
                                    break;
                                  case 2:
                                    {
                                      _editedJob = Job(
                                        id: _editedJob.id,
                                        title: _editedJob.title,
                                        description:
                                            'Four Way Lights \u{1F6A6}\u{1F6A6}\u{1F6A6}\u{1F6A6}',
                                        postcode: _editedJob.postcode,
                                        payRate: _editedJob.payRate,
                                        vehicleRequired:
                                            _editedJob.vehicleRequired,
                                        lightConfig: _editedJob.lightConfig,
                                        endDate: _editedJob.endDate,
                                      );
                                    }
                                    break;
                                  default:
                                    {
                                      _editedJob = Job(
                                        id: _editedJob.id,
                                        title: _editedJob.title,
                                        description: 'Two Way Lights',
                                        postcode: _editedJob.postcode,
                                        payRate: _editedJob.payRate,
                                        vehicleRequired:
                                            _editedJob.vehicleRequired,
                                        lightConfig: _editedJob.lightConfig,
                                        endDate: _editedJob.endDate,
                                      );
                                    }
                                    break;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          )
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
