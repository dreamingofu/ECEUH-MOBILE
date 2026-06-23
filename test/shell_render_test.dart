import 'package:eceuh/app.dart';
import 'package:eceuh/screens/home_screen.dart';
import 'package:eceuh/services/progress_service.dart';
import 'package:eceuh/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('AppShell: body renders — Home screen content visible', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService(prefs)..load()),
          ChangeNotifierProvider(create: (_) => ProgressService(prefs)..load()),
        ],
        child: const EceuhApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    // Debug sizes
    final homeEl = find.byType(HomeScreen).evaluate().first;
    debugPrint('HomeScreen size: ${homeEl.renderObject?.paintBounds.size}');
    for (final el in find.byType(Navigator).evaluate()) {
      debugPrint('Navigator size: ${el.renderObject?.paintBounds.size}');
    }

    // The real assertions
    expect(find.text('ELITE ENGINEERING'), findsOneWidget, reason: 'Brand bar must show');
    expect(find.text('Academy'), findsOneWidget, reason: 'Pill nav must show');
    expect(find.textContaining('UNIVERSITY OF HOUSTON'), findsOneWidget,
        reason: 'Home screen body content must be visible');
  });
}
