import 'package:flutter_test/flutter_test.dart';
import 'package:jexplore/main.dart';

void main() {
  testWidgets('JExplore app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const JExploreApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(JExploreApp), findsOneWidget);
  });
}
