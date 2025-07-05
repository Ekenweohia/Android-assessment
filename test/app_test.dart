
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';

void main() {
  testWidgets('App starts on Login screen', (WidgetTester tester) async {
   
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    
    await tester.pumpAndSettle();

    
    expect(find.text('Login'), findsOneWidget);
  });
}
