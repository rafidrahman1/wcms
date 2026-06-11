import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/app.dart';
import 'package:wms/features/waste/presentation/providers/waste_providers.dart';

void main() {
  testWidgets('WMS app launches', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wasteItemsStreamProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const WmsApp(),
      ),
    );

    expect(find.text('WMS'), findsOneWidget);
    expect(find.text('Log Waste'), findsOneWidget);
    expect(find.text('Records'), findsOneWidget);
    expect(find.text('Member ID'), findsOneWidget);
  });
}
