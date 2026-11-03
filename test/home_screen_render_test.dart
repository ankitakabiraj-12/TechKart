import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techkart/navigation/home.dart';

void main() {
  final widths = [320.0, 360.0, 390.0, 412.0, 480.0, 600.0];

  for (final width in widths) {
    testWidgets('HomeScreen renders without overflow on width $width', (tester) async {
      FlutterErrorDetails? caughtDetails;
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        caughtDetails = details;
        originalOnError?.call(details);
      };

      tester.view.physicalSize = Size(width * 2.5, 844 * 2.5);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(() => FlutterError.onError = originalOnError);

      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      if (caughtDetails != null) {
        // ignore: avoid_print
        print('FULL ERROR: ${caughtDetails.toString()}');
      }
      expect(tester.takeException(), isNull);
    });
  }
}
