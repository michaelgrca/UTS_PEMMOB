import 'package:flutter_test/flutter_test.dart';
import 'package:tunas_quiz/app.dart';

void main() {
  testWidgets('home screen asks for a name and a topic', (tester) async {
    await tester.pumpWidget(const TunasApp());
    await tester.pumpAndSettle();

    expect(find.text('Siapa namamu?'), findsOneWidget);
    expect(find.text('Mulai kuis'), findsOneWidget);
    expect(find.text('Rimba & Satwa'), findsOneWidget);
    expect(find.text('Bumi & Iklim'), findsOneWidget);
    expect(find.text('Sains Hijau'), findsOneWidget);
  });
}
