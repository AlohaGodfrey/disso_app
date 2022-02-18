import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/show_cool_dialog.dart' as custom_dialog;
import '../models/job.dart';
import '../theme/palette.dart';
import '../widgets/job_details_text.dart';
import '../helpers/location_helper.dart';
import '../widgets/app_drawer.dart';

class JobActiveScreen extends StatefulWidget {
  static const routeName = '/job-active';
  JobActiveScreen({Key? key}) : super(key: key);

  @override
  _JobActiveScreenState createState() => _JobActiveScreenState();
}

class _JobActiveScreenState extends State<JobActiveScreen> {
  List<bool> _isSelected = [false, false];
  var _jobStartPanel = true;
  var _switchPanel = true;
  var _breakPanel = true;
  CountDownController _clockController = CountDownController();
  final int _initDuration = 12; //calculate this from DateTime.now().toIso...
  double _elaspedTime = 0;
  //timer for the internals
  final _stopWatch = Stopwatch();
  //pretend 12 seconds tranlates to 12 hours

  @override
  Widget build(BuildContext context) {
    final Job currentJob = ModalRoute.of(context)!.settings.arguments as Job;
    final scaffold = ScaffoldMessenger.of(context); //use for small snackbar txt
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Job'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            CircularCountDownTimer(
              // duration: 43200,
              duration: _initDuration,
              initialDuration: 0,
              controller: _clockController,
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 1.9,
              ringColor: Palette.kToDark,
              ringGradient: null,
              fillColor: Palette.bToLight,
              fillGradient: null,
              backgroundColor: Palette.kToLight.shade100,
              backgroundGradient: null,
              strokeWidth: 10.0,
              strokeCap: StrokeCap.round,
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
                // print('Countdown Started');
              },
              onComplete: () {
                custom_dialog.activeJobDone(
                    context: context,
                    activeJob: currentJob,
                    stopwatch: _stopWatch,
                    earlyFinish: false,
                    clockController: _clockController);
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
                                _stopWatch.start();

                                const SnackBar(
                                  content: Text(
                                    'Resuming Shift',
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                              break;
                            case 2:
                              custom_dialog.activeJobDone(
                                  context: context,
                                  activeJob: currentJob,
                                  stopwatch: _stopWatch,
                                  earlyFinish: false,
                                  clockController: _clockController);

                              break;
                            default:
                              {}
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
                                _stopWatch.stop();
                              }
                              break;
                            case 1:
                              {}
                              break;
                            case 2:
                              {
                                custom_dialog.activeJobDone(
                                    context: context,
                                    activeJob: currentJob,
                                    stopwatch: _stopWatch,
                                    earlyFinish: true,
                                    clockController: _clockController);
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
                          setState(() {
                            _jobStartPanel = false;
                            _switchPanel = false;
                            _clockController.start();
                            _stopWatch.start();
                          });
                          scaffold.showSnackBar(
                            const SnackBar(
                              content: Text(
                                '...Starting Shift... Tracking disabled',
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
            const Spacer(),
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
