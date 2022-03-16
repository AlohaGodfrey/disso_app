import 'package:disso_app/models/job_model.dart';
import 'package:disso_app/providers/auth.dart';
import 'package:disso_app/providers/jobs_firebase.dart';
import 'package:disso_app/providers/timesheets_firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Auth sutAuth;
  late JobsFirebase sutJobs;
  late TimesheetsFirebase sutTimesheet;

  setUp(() {
    sutAuth = Auth();
    sutJobs = JobsFirebase([], authToken: '', authUserId: '');
    sutTimesheet = TimesheetsFirebase('', '', []);
  });

  group("Providers: ", () {
    test(
      "Initial Auth values are correct",
      () {
        expect(sutAuth.isAdmin, false);
      },
    );

    test(
      "Initial Jobs Firebase values are correct",
      () {
        expect(sutJobs.jobItems, []);
      },
    );

    test(
      "Jobs_Firebase converts anyTransport Text to anyTransport Enum",
      () {
        final result = sutJobs.retrieveVehicleRequirments('anyTransport');
        expect(result, VehicleRequired.anyTransport);
      },
    );

    test(
      "Jobs_Firebase converts carOnly Text to carOnly Enum",
      () {
        final result = sutJobs.retrieveVehicleRequirments('carOnly');
        expect(result, VehicleRequired.carOnly);
      },
    );

    test(
      "Jobs_Firebase converts noParking Text to noParking Enum",
      () {
        final result = sutJobs.retrieveVehicleRequirments('noParking');
        expect(result, VehicleRequired.noParking);
      },
    );

    test(
      "Jobs_Firebase converts invalid text to default anyTransport Enum",
      () {
        final result = sutJobs.retrieveVehicleRequirments('invalid text');
        expect(result, VehicleRequired.anyTransport);
      },
    );

    test(
      "Jobs_Firebase converts twoWay text to twoWay LightConfig Enum",
      () {
        final result = sutJobs.retrieveLightConfig('twoWay');
        expect(result, LightConfig.twoWay);
      },
    );

    test(
      "Jobs_Firebase converts threeWay text to threeWay LightConfig Enum",
      () {
        final result = sutJobs.retrieveLightConfig('threeWay');
        expect(result, LightConfig.threeWay);
      },
    );

    test(
      "Jobs_Firebase converts fourWay text to fourWay LightConfig Enum",
      () {
        final result = sutJobs.retrieveLightConfig('fourWay');
        expect(result, LightConfig.fourWay);
      },
    );

    test(
      "Jobs_Firebase converts invalid text to default twoWay LightConfig Enum",
      () {
        final result = sutJobs.retrieveLightConfig('invalid text');
        expect(result, LightConfig.twoWay);
      },
    );

    test(
      "Initial Timesheets Firebase values are correct",
      () {
        expect(sutTimesheet.timesheet, []);
      },
    );

    test(
      "Timesheets Firebase converts time \'08:30:00\' accurately to 8.5",
      () {
        final result = TimesheetsFirebase.calculateTimeWorked('08:30:00');
        expect(result, 8.5);
      },
    );
  });
}
