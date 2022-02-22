import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/Job.dart';
import '../providers/Jobs.dart';
import '../models/Job.dart';
import '../theme/palette.dart';
import './job_details_text.dart';

class NewJobForm extends StatefulWidget {
  @override
  State<NewJobForm> createState() => _NewJobFormState();
}

class _NewJobFormState extends State<NewJobForm> {
  // const NewJobForm({Key? key}) : super(key: key);
  final _postCodeFocusNode = FocusNode();
  final _payRateFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  DateTime? _selectedDate;
  LightConfig? tempLightConfig;
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
  var _isloading = false;
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
      // _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
            decoration: const InputDecoration(labelText: 'Site Area'),
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
              _editedJob = Job(
                id: _editedJob.id,
                title: value as String,
                description: _editedJob.description,
                postcode: _editedJob.postcode,
                payRate: _editedJob.payRate,
                endDate: _editedJob.endDate,
              );
            },
          ),
          TextFormField(
            initialValue: _initValues['postcode'],
            decoration: const InputDecoration(labelText: 'PostCode'),
            textInputAction: TextInputAction.next,
            focusNode: _postCodeFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_payRateFocusNode);
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
              );
            },
          ),
          TextFormField(
            initialValue: _initValues['payRate'],
            decoration: const InputDecoration(labelText: 'Pay Rate [£13.50]'),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            focusNode: _payRateFocusNode,
            // onFieldSubmitted: (_) {
            //   FocusScope.of(context).requestFocus(_postCodeFocusNode);
            // },
            onSaved: (value) {
              _editedJob = Job(
                id: _editedJob.id,
                title: value as String,
                description: _editedJob.description,
                postcode: _editedJob.postcode,
                payRate: double.parse(value),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
              minWidth: MediaQuery.of(context).size.width * 0.40,
              minHeight: 40,
              activeFgColor: Colors.white,
              totalSwitches: 2,
              labels: const ['Any Transport', 'Car Only'],
              icons: const [
                IconData(0xe0de, fontFamily: 'MaterialIcons'),
                IconData(0xe208, fontFamily: 'MaterialIcons'),
              ],
              initialLabelIndex: _editedJob.vehicleRequired ? 1 : 0,
              activeBgColors: const [
                [Palette.kToLight],
                [Palette.kToLight],
              ],
              cornerRadius: 20,
              onToggle: (index) {},
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
              minWidth: MediaQuery.of(context).size.width * 0.27,
              minHeight: 40,
              activeFgColor: Colors.white,
              totalSwitches: 3,
              labels: const ['Two-Way', 'Three-Way', 'Four-Way'],
              // icons: const [
              //   FontAwesomeIcons.utensils,
              //   FontAwesomeIcons.play,
              //   FontAwesomeIcons.home
              // ],
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
                      tempLightConfig = LightConfig.twoWay;
                    }
                    return;
                  case 1:
                    {
                      tempLightConfig = LightConfig.threeWay;
                    }
                    return;
                  case 2:
                    {
                      tempLightConfig = LightConfig.fourWay;
                    }
                    return;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


// Job(
//       id: 'p1',
//       title: 'Islington',
//       description: 'Two way lights',
//       endDate: DateTime.now(),
//       postcode: 'HP11 2et',
//     ),

//  final String id;
//   final String title;
//   final String postcode;
//   final String description;
//   final DateTime endDate;
//   final PlaceLocation location;
//   //either car required or public transport.
//   final bool vehicleRequired; //should be enum for later use
//   final double payRate;
//   final LightConfig lightConfig;