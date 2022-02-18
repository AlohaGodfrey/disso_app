import 'package:disso_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cool_alert/cool_alert.dart';

import '../models/Job.dart';
import '../theme/palette.dart';
import '../widgets/job_details_text.dart';
import '../helpers/location_helper.dart';

class JobActiveScreen extends StatefulWidget {
  static const routeName = '/job-active';
  JobActiveScreen({Key? key}) : super(key: key);
  //add code to connect current job to user job

  @override
  _JobActiveScreenState createState() => _JobActiveScreenState();
}

class _JobActiveScreenState extends State<JobActiveScreen> {
  List<bool> _isSelected = [false, false];
  var _jobStartPanel = true;
  var _switchPanel = true;
  var _breakPanel = true;
  CountDownController _clockController = CountDownController();
  int _duration = 20; //calculate this from DateTime.now().toIso...

  @override
  Widget build(BuildContext context) {
    final Job currentJob = ModalRoute.of(context)!.settings.arguments as Job;
    final _previewImageUrl = LocationHelper.generateLocationPreviewImage(
        latitute: currentJob.location.latitude,
        longitude: currentJob.location.longitude);
    final scaffold = ScaffoldMessenger.of(context); //use for small snackbar txt
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Job'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   width: 200,
            //   height: 100,
            //   child: LocationInput(_previewImageUrl),
            // ),
            Spacer(),
            CircularCountDownTimer(
              // duration: 43200,
              duration: _duration,
              initialDuration: 0,
              controller: _clockController,
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 1.9,
              ringColor: Palette.kToDark,
              // ringColor: Color.fromARGB(255, 224, 224, 224),
              ringGradient: null,
              fillColor: Palette.bToLight,
              // fillColor: Color.fromARGB(255, 234, 128, 252),
              fillGradient: null,
              backgroundColor: Palette.kToLight.shade100,
              backgroundGradient: null,
              strokeWidth: 10.0,
              strokeCap: StrokeCap.round,
              // textStyle: TextStyle(
              //     fontSize: 33.0,
              //     color: Colors.white,
              //     // color: Palette.kToLight.shade600,
              //     fontWeight: FontWeight.normal),
              textStyle: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              textFormat: CountdownTextFormat.HH_MM_SS,
              isReverse: false,
              isReverseAnimation: false,
              isTimerTextShown: true,
              autoStart: false,

              onStart: () {
                print('Countdown Started');
              },
              onComplete: () {
                print('Countdown Ended');
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.confirm,
                    backgroundColor: Palette.bToDark,
                    title: 'Shift Complete',
                    text: "Press Ok to save a digital timesheet",
                    // animType: CoolAlertAnimType.slideInRight,
                    // loopAnimation: true,
                    onConfirmBtnTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    });
              },
            ),
            Container(
              height: 80,
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(136, 212, 212, 212),
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    ),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    key: UniqueKey(),
                    visible: !_breakPanel,
                    child: ToggleSwitch(
                      minWidth: MediaQuery.of(context).size.width * 0.28,
                      minHeight: 55,
                      activeFgColor: Colors.white,
                      // inactiveFgColor: Colors.white,
                      totalSwitches: 3,
                      labels: const ['On break', 'Resume', 'Clock Out'],
                      icons: const [
                        FontAwesomeIcons.utensils,
                        FontAwesomeIcons.play,
                        FontAwesomeIcons.home
                      ],
                      initialLabelIndex: 0,
                      activeBgColors: const [
                        [Palette.kToLight],
                        [Palette.kToLight],
                        [Colors.red]
                      ],
                      cornerRadius: 20,

                      onToggle: (index) async {
                        await Future.delayed(const Duration(milliseconds: 200));
                        setState(() {
                          switch (index) {
                            case 0:
                              {}
                              break;
                            case 1:
                              {
                                const SnackBar(
                                  content: Text(
                                    'Resuming Shift',
                                    textAlign: TextAlign.center,
                                  ),
                                );
                                _switchPanel = !_switchPanel;
                                _breakPanel = !_breakPanel;
                                _clockController.resume();
                                const SnackBar(
                                  content: Text(
                                    'Resuming Shift',
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                              break;
                            case 2:
                              CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.confirm,
                                  backgroundColor: Palette.bToDark,
                                  title: 'Clocking Out',
                                  text: "Do you want to end your shift?",
                                  // animType: CoolAlertAnimType.slideInRight,
                                  // loopAnimation: true,
                                  onConfirmBtnTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  });
                              break;
                            default:
                              {
                                //statements;
                              }
                              break;
                          }
                        });
                      },
                    ),
                  ),
                  Visibility(
                    key: UniqueKey(),
                    visible: !_switchPanel,
                    child: ToggleSwitch(
                      minWidth: MediaQuery.of(context).size.width * 0.28,
                      minHeight: 55,
                      animate: true,
                      animationDuration: 200,
                      curve: Curves.bounceInOut,
                      totalSwitches: 3,
                      activeFgColor: Colors.white,
                      cornerRadius: 16,
                      // inactiveFgColor: Colors.white,
                      labels: const ['Break', 'On-Site', 'Clock Out'],
                      initialLabelIndex: 1,
                      iconSize: 20,
                      activeBgColors: const [
                        [Palette.kToLight],
                        [Palette.kToLight],
                        [Colors.red]
                      ],
                      icons: const [
                        FontAwesomeIcons.utensils,
                        FontAwesomeIcons.satelliteDish,
                        FontAwesomeIcons.home
                      ],
                      onToggle: (index) async {
                        await Future.delayed(const Duration(milliseconds: 200));

                        setState(() {
                          switch (index) {
                            case 0:
                              {
                                _switchPanel = !_switchPanel;
                                _breakPanel = !_breakPanel;
                                _clockController.pause();
                              }
                              break;
                            case 1:
                              {}
                              break;
                            case 2:
                              {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    backgroundColor: Palette.bToDark,
                                    title: 'Clocking Out',
                                    text: "Do you want to end your shift?",
                                    // animType: CoolAlertAnimType.slideInRight,
                                    // loopAnimation: true,
                                    onConfirmBtnTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    });
                              }
                              break;
                            default:
                              {
                                //statements;
                              }
                              break;
                          }
                        });
                      },
                    ),
                  ),
                  //Clock in Button
                  Expanded(
                    child: Visibility(
                      key: UniqueKey(),
                      visible: _jobStartPanel,
                      child: ToggleSwitch(
                        minWidth: MediaQuery.of(context).size.width * 0.85,
                        minHeight: 50,
                        animate: true,
                        animationDuration: 200,
                        curve: Curves.bounceInOut,
                        initialLabelIndex: 0,
                        cornerRadius: 16,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.transparent,
                        inactiveFgColor: Colors.white,
                        totalSwitches: 1,
                        labels: const ['Clock In'],
                        icons: const [
                          FontAwesomeIcons.play,
                        ],
                        activeBgColors: const [
                          [Colors.blue]
                        ],
                        onToggle: (index) {
                          print('switched to: $index');
                          setState(() {
                            _jobStartPanel = false;
                            _switchPanel = false;
                            _clockController.start();
                          });
                          scaffold.showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Starting Shift. Tracking disabled',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            jobDetailPanel(currentJob),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
