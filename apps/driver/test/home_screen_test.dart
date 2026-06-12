import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truxify_driver/controllers/app_controller.dart';
import 'package:truxify_driver/core/app_routes.dart';
import 'package:truxify_driver/screens/destination_picker_screen.dart';
import 'package:truxify_driver/screens/shell_screen.dart';
import 'package:truxify_driver/theme/app_theme.dart';

Widget _buildTestApp() {
  final controller = TruxifyController();

  return TruxifyScope(
    controller: controller,
    child: MaterialApp(
      theme: TruxifyTheme.light(),
      home: const ShellScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.destinationPicker) {
          final args = settings.arguments as DestinationPickerArgs?;
          return MaterialPageRoute<void>(
            builder: (_) => DestinationPickerScreen(
              title: args?.title ?? 'Select Destination',
              initialQuery: args?.initialQuery,
              initialPoint: args?.initialPoint,
            ),
          );
        }

        return MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: SizedBox.shrink()),
        );
      },
    ),
  );
}

Future<void> _pumpTransition(WidgetTester tester) async {
  for (int i = 0; i < 15; i++) {
    await tester.pump(const Duration(milliseconds: 30));
  }
}

void main() {
  testWidgets('driver home shows loading state and then map with bottom sheet', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

    expect(find.text('Fetching your location...'), findsOneWidget);

    await _pumpTransition(tester);

    expect(find.text('Fetching your location...'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Stack), findsWidgets);
  });
}
