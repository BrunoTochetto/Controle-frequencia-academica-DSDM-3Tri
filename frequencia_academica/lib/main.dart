import 'package:flutter/material.dart';

import 'repositories/api_frequencia_repository.dart';
import 'src/pages/busca_estudantes.dart';
import 'src/pages/busca_turmas.dart';
import 'src/pages/cadastro_estudante.dart';
import 'src/pages/cadastro_turma.dart';
import 'src/pages/inicial.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repositorio = ApiFrequenciaRepository();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle de Frequência',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Inicial(),
        '/turmas': (context) => BuscaTurmas(repositorio: repositorio),
        '/estudantes': (context) => BuscaEstudantes(repositorio: repositorio),
        '/cadastrar-turma': (context) => CadastroTurma(repositorio: repositorio),
        '/cadastrar-estudante': (context) =>
            CadastroEstudante(repositorio: repositorio),
      },
    );
  }
}