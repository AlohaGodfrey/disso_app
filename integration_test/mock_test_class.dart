import 'package:disso_app/models/job_model.dart';
import 'package:disso_app/providers/auth.dart';
import 'package:disso_app/providers/jobs_firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuth extends Mock implements Auth {
  String? userID;
  String? userToken;

  @override
  var isAdmin = false;

  @override
  Future<void> login(String email, String password, bool isAdminAuth) async {
    userID = 'uid';
    userToken = 'userToken';
    isAdmin = isAdminAuth;
  }

  set toggleAdminStatus(bool flag) {
    isAdmin = flag;
  }

  @override
  Future<void> signup(String email, String password, bool isAdminAuth) async {
    userID = 'uid';
    userToken = 'userToken';
    isAdmin = isAdminAuth;
  }
}

class MockJobsFirebase extends Mock implements JobsFirebase {
  List<Job> _jobItems = [];

  MockJobsFirebase();

  //getter
  @override
  List<Job> get jobItems {
    return [..._jobItems];
  }

  //setter

  //update job list

  //delete job item

  //fetch job list
  @override
  Future<void> fetchAndSetJobs() async {
    _jobItems = [
      Job(
          id: 'x1',
          title: 'Caledonian',
          description: 'Two Way Lights',
          endDate: DateTime.now(),
          postcode: 'HP135GG'),
      Job(
          id: 'x2',
          title: 'Kingston',
          description: 'Two Way Lights',
          endDate: DateTime.now(),
          postcode: 'KTG66'),
      Job(
          id: 'x3',
          title: 'Streatham',
          description: 'Two Way Lights',
          endDate: DateTime.now(),
          postcode: 'SE12XY')
    ];
  }
  //removeed the override as it stop mockito from
  //verifying object has been called without drastic work around
  //clear list
  // @override
  // void clearJobList() {
  //   _jobItems = [];
  // }
}
