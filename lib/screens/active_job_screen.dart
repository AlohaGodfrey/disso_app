import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:disso_app/widgets/location_input.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import '../theme/palette.dart';
import '../models/job_model.dart';
import '../helpers/location_service.dart';
import '../widgets/details_job_widgets.dart';
import '../widgets/show_dialog.dart' as custom_dialog;

class ActiveJobScreen extends StatefulWidget {
  final Job currentJob;
  const ActiveJobScreen(this.currentJob, {Key? key}) : super(key: key);

  @override
  _ActiveJobScreenState createState() => _ActiveJobScreenState();
}

class _ActiveJobScreenState extends State<ActiveJobScreen> {
  var _jobStartPanel = true;
  var _switchPanel = true;
  var _breakPanel = true;
  //simluates 12 hours shift in 12 seconds
  final int _timerMaxDuration = 43200;
  final int _timeInitDuration = 30600;
  //visual timer for user counting down
  final CountDownController _clockController = CountDownController();
  //internal stopwatch for calculations counting up
  final _stopWatch = Stopwatch();

  @override
  Widget build(BuildContext context) {
    final _previewImageUrl = LocationService.generateLocationPreviewImage(
        latitute: widget.currentJob.location.latitude,
        longitude: widget.currentJob.location.longitude);
    final scaffold = ScaffoldMessenger.of(context); //use for small snackbar txt

    //screen size optimizations
    var deviceSize = MediaQuery.of(context).size;
    bool isSmallScreen = deviceSize.width > 650;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Job'),
      ),
      body: Center(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // shrinkWrap: true,
          children: [
            Container(
              child: LocationInput(_previewImageUrl),
              height: MediaQuery.of(context).size.height * 0.1,
              margin: deviceSize.width > 800
                  ? EdgeInsets.symmetric(
                      horizontal: deviceSize.width * 0.2, vertical: 12)
                  : const EdgeInsets.all(12),
            ),
            CircularCountDownTimer(
              duration: _timerMaxDuration,
              initialDuration: _timeInitDuration,
              controller: _clockController,
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.42,
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
                    activeJob: widget.currentJob,
                    stopwatch: _stopWatch,
                    isEarlyFinish: false,
                    clockController: _clockController);
              },
            ),
            Container(
              height: 80,
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              // margin: const EdgeInsets.symmetric(
              //   horizontal: 16,
              // ),
              margin: isSmallScreen
                  ? EdgeInsets.symmetric(
                      horizontal: deviceSize.width * 0.2, vertical: 16)
                  : const EdgeInsets.only(top: 16, left: 16, right: 16),
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
                      // minWidth: MediaQuery.of(context).size.width * 0.28,
                      minWidth: isSmallScreen
                          ? deviceSize.width * 0.17
                          : deviceSize.width * 0.27,
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
                                  activeJob: widget.currentJob,
                                  stopwatch: _stopWatch,
                                  isEarlyFinish: false,
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
                      // minWidth: MediaQuery.of(context).size.width * 0.28,
                      minWidth: isSmallScreen
                          ? deviceSize.width * 0.17
                          : deviceSize.width * 0.27,
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
                                    activeJob: widget.currentJob,
                                    stopwatch: _stopWatch,
                                    isEarlyFinish: true,
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
                        // minWidth: MediaQuery.of(context).size.width * 0.85,
                        minWidth: isSmallScreen
                            ? deviceSize.width * 0.5
                            : deviceSize.width * 0.85,
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
                                'Online',
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
            // const Spacer(),
            const SizedBox(
              height: 5,
            ),
            jobDetailPanel(widget.currentJob, deviceSize),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
