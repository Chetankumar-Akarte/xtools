import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xtools/xtools.dart';

void main() {
  group('XButton Tests', () {
    testWidgets('Renders correctly with label and handles tap', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: XButton(
              label: 'Submit',
              onPressed: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      // Verify the label is rendered
      expect(find.text('Submit'), findsOneWidget);

      // Verify no loading indicator is present
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Simulate a tap
      await tester.tap(find.byType(XButton));
      await tester.pump();

      // Verify the callback was triggered
      expect(wasTapped, isTrue);
    });

    testWidgets('Shows loading state and disables tap', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: XButton(
              label: 'Submit',
              isLoading: true,
              onPressed: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      // Verify the loading indicator is present
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Verify the text is hidden during loading
      expect(find.text('Submit'), findsNothing);

      // Simulate a tap
      await tester.tap(find.byType(XButton));
      await tester.pump();

      // Verify the callback was NOT triggered because the button is loading/disabled
      expect(wasTapped, isFalse);
    });
  });

  group('XShimmer Tests', () {
    testWidgets('Renders base shimmer and static helpers without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                XShimmer.text(lines: 2),
                XShimmer.avatar(radius: 20),
                Expanded(child: XShimmer.list(itemCount: 3)),
              ],
            ),
          ),
        ),
      );

      // Verify that the XShimmer widget is injected multiple times by our helpers
      expect(find.byType(XShimmer), findsWidgets);

      // Verify the list helper actually generated the requested number of items
      // XShimmer.list generates a ListView.builder, so we pump it to build the items
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('XToast Tests', () {
    testWidgets('Shows SnackBar with correct message', (WidgetTester tester) async {
      const testMessage = 'Operation successful!';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            // We need a Builder to get a BuildContext that contains a Scaffold
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    XToast.show(context, message: testMessage, type: XToastType.success);
                  },
                  child: const Text('Show Toast'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to trigger the toast
      await tester.tap(find.text('Show Toast'));

      // Pump a frame to start the SnackBar animation
      await tester.pump();
      // Pump a bit more time to let the SnackBar fully slide onto the screen
      await tester.pump(const Duration(milliseconds: 100));

      // Verify the SnackBar is displayed with the correct text
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(testMessage), findsOneWidget);

      // Verify the success icon is present
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });
  });
}