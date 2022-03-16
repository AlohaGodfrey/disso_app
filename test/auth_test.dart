import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../lib/providers/auth.dart';

class MockJobsFirbase extends Mock implements Auth {}

void main() {
  late Auth sut;

  setUp(() {
    sut = Auth();
  });

  test(
    "initial auth values are correct",
    () {
      expect(sut.isAdmin, false);
    },
  );

  group("Auth", () {
    test(
      "user is authenticated",
      () async {
        when(() => MockJobsFirbase().login('test@gmail.com', '123456', false))
            .thenAnswer((_) async => []);
        await sut.login('test@gmail.com', '123456', false);
        verify(() => MockJobsFirbase().login('test@gmail.com', '123456', false))
            .called(1);
      },
    );
  });
}
