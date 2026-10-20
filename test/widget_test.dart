import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunas_quiz/app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('home screen asks for a name and a topic', (tester) async {
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(TunasApp(preferences: preferences));
    await tester.pumpAndSettle();

    expect(find.text('Siapa namamu?'), findsOneWidget);
    expect(find.text('Mulai kuis'), findsOneWidget);
    expect(find.text('Rimba & Satwa'), findsOneWidget);
    expect(find.text('Bumi & Iklim'), findsOneWidget);
    expect(find.text('Sains Hijau'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);
  });

  testWidgets('settings screen exposes appearance and local data', (
    tester,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(TunasApp(preferences: preferences));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pengaturan'));
    await tester.pumpAndSettle();

    expect(find.text('Mode warna'), findsOneWidget);
    expect(find.text('Sistem'), findsOneWidget);
    expect(find.text('Terang'), findsOneWidget);
    expect(find.text('Gelap'), findsOneWidget);
    expect(find.text('0 sesi tersimpan'), findsOneWidget);
  });
}
