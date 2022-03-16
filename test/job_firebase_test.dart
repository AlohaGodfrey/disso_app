import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../lib/providers/jobs_firebase.dart';

class MockJobsFirbase extends Mock implements JobsFirebase {}

void main() {
  late JobsFirebase sut;

  setUp(() {});
}
