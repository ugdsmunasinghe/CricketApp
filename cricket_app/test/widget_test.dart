// This is a basic Flutter widget test for the Mini Cricket app.
//
// It verifies:
//   1. The initial state shows "Mini Cricket", Runs = 0, Balls = 6,
//      and a "Bat" button.
//   2. Tapping "Bat" 6 times produces the scripted sequence:
//        3 runs / 5 balls, 3 runs / 4 balls, 4 runs / 3 balls,
//        4 runs / 2 balls, 4 runs / 1 ball, 10 runs / 0 balls.
//   3. When balls reach 0, the button changes to "Restart".
//   4. Tapping "Restart" resets the game to 0 runs and 6 balls.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// 👇 Change this import to match YOUR actual file path & project name.
// If your project is named `cricket_app` and MiniCricketScreen lives in
// lib/minicricketscreen.dart, the line below is correct.
import 'package:cricket_app/minicricketscreen.dart';

void main() {
  group('Mini Cricket app', () {
    // Small helper so we don't repeat the MaterialApp wrapper everywhere.
    Widget buildApp() => const MaterialApp(home: MiniCricketScreen());

    testWidgets('shows initial state: 0 runs, 6 balls, Bat button',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      // Title in the AppBar
      expect(find.text('Mini Cricket'), findsOneWidget);

      // Labels
      expect(find.text('Runs'), findsOneWidget);
      expect(find.text('Balls'), findsOneWidget);

      // Initial score values: Runs = 0, Balls = 6
      expect(find.text('0'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);

      // Bat is visible, Restart is not
      expect(find.text('Bat'), findsOneWidget);
      expect(find.text('Restart'), findsNothing);
    });

    testWidgets('plays the scripted sequence and reaches game over',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      // Expected running totals after each tap (runs, ballsLeft)
      // Script is [3, 0, 1, 0, 0, 6]
      const expected = [
        [3, 5],
        [3, 4],
        [4, 3],
        [4, 2],
        [1, 1],
        [10, 0],
      ];

      for (int i = 0; i < expected.length; i++) {
        // Tap Bat
        await tester.tap(find.text('Bat'));
        await tester.pump(); // kick off reveal animation
        await tester.pump(const Duration(milliseconds: 800)); // wait for delay

        final runs = expected[i][0].toString();
        final balls = expected[i][1].toString();

        expect(find.text(runs), findsOneWidget,
            reason: 'After tap ${i + 1}, Runs should be $runs');
        expect(find.text(balls), findsOneWidget,
            reason: 'After tap ${i + 1}, Balls should be $balls');
      }

      // After 6 taps, game is over
      expect(find.text('Bat'), findsNothing);
      expect(find.text('Restart'), findsOneWidget);
    });

    testWidgets('Restart resets score to 0 runs and 6 balls',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      // Play all 6 balls to reach game over
      for (int i = 0; i < 6; i++) {
        await tester.tap(find.text('Bat'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 800));
      }

      expect(find.text('Restart'), findsOneWidget);

      // Tap Restart
      await tester.tap(find.text('Restart'));
      await tester.pumpAndSettle();

      // Reset expectations
      expect(find.text('0'), findsOneWidget); // Runs = 0
      expect(find.text('6'), findsOneWidget); // Balls = 6
      expect(find.text('Bat'), findsOneWidget);
      expect(find.text('Restart'), findsNothing);
    });
  });
}