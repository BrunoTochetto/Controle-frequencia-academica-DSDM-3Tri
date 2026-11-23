import 'package:flutter_test/flutter_test.dart';

import 'package:frequencia_academica/main.dart';

void main() {
  testWidgets('Exibe as opções principais do sistema', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Controle de Frequência'), findsOneWidget);
    expect(find.text('Buscar turma'), findsOneWidget);
    expect(find.text('Buscar estudante'), findsOneWidget);
  });
}
