import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import '../model/estudante.dart';
import '../model/turma.dart';

class ApiFrequenciaRepository {
  final http.Client cliente;

  ApiFrequenciaRepository({http.Client? cliente}) : cliente = cliente ?? http.Client();

  Future<List<Turma>> buscarTurmas({required String consulta, required int pagina}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/turmas').replace(
      queryParameters: {'q': consulta, 'pagina': '$pagina', 'limite': '20'},
    );

    final resposta = await cliente.get(uri);
    if (resposta.statusCode != 200) {
      throw Exception('Não foi possível buscar as turmas.');
    }

    final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
    final resultados = dados['dados'] as List<dynamic>? ?? const [];
    return resultados.map((item) => Turma.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<List<Estudante>> buscarEstudantes({required String consulta, required int pagina}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/estudantes').replace(
      queryParameters: {'q': consulta, 'pagina': '$pagina', 'limite': '20'},
    );

    final resposta = await cliente.get(uri);
    if (resposta.statusCode != 200) {
      throw Exception('Não foi possível buscar os estudantes.');
    }

    final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
    final resultados = dados['dados'] as List<dynamic>? ?? const [];
    return resultados.map((item) => Estudante.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> registrarFaltas(String identificadorTurma, List<int> idsEstudantesFaltosos) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/turmas/$identificadorTurma/faltas');
    final resposta = await cliente.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estudantesIds': idsEstudantesFaltosos}),
    );

    if (resposta.statusCode != 200) {
      throw Exception('Não foi possível registrar as faltas.');
    }
  }

  Future<Turma> cadastrarTurma(String identificador) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/turmas');
    final resposta = await cliente.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identificador': identificador}),
    );

    if (resposta.statusCode != 201) {
      final dados = jsonDecode(resposta.body);
      throw Exception(dados['mensagem'] ?? 'Não foi possível cadastrar a turma.');
    }

    return Turma.fromJson(jsonDecode(resposta.body) as Map<String, dynamic>);
  }

  Future<Estudante> cadastrarEstudante({
    required String nome,
    required int id,
    required int idade,
    required String turma,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/estudantes');
    final resposta = await cliente.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'id': id,
        'idade': idade,
        'turma': turma,
      }),
    );

    if (resposta.statusCode != 201) {
      final dados = jsonDecode(resposta.body);
      throw Exception(dados['mensagem'] ?? 'Não foi possível cadastrar o estudante.');
    }

    return Estudante.fromJson(jsonDecode(resposta.body) as Map<String, dynamic>);
  }

  Future<List<Turma>> listarTurmas() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/turmas').replace(
      queryParameters: {'pagina': '1', 'limite': '100'},
    );

    final resposta = await cliente.get(uri);
    if (resposta.statusCode != 200) {
      throw Exception('Não foi possível carregar as turmas.');
    }

    final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
    final resultados = dados['dados'] as List<dynamic>? ?? const [];
    return resultados.map((item) => Turma.fromJson(item as Map<String, dynamic>)).toList();
  }
}
