import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mi_app/main.dart';

void main() {
  testWidgets('renders login screen title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('Gestión Clínica'), findsOneWidget);
  });
}
