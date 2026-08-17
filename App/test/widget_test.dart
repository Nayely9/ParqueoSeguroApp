import 'package:flutter_test/flutter_test.dart';

import 'package:parqueo_seguro_app/main.dart';

void main() {
  testWidgets('ParqueoSeguroApp se inicia correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ParqueoSeguroApp());

    expect(find.text('ParqueoSeguroApp'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Crear una cuenta'), findsOneWidget);
  });
}