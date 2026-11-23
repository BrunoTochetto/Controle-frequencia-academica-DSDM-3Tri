import 'estudante.dart';

class Turma {
  final String identificador;
  final List<Estudante> alunos;

  const Turma({
    required this.identificador,
    this.alunos = const [],
  });

  int get quantidadeAlunos => alunos.length;

  factory Turma.fromJson(Map<String, dynamic> json) {
    final alunosJson = json['alunos'] as List<dynamic>? ?? const [];

    return Turma(
      identificador: json['identificador'].toString(),
      alunos: alunosJson
          .map((item) => Estudante.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identificador': identificador,
      'alunos': alunos.map((aluno) => aluno.toJson()).toList(),
      'quantidadeAlunos': quantidadeAlunos,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Turma && identificador == other.identificador;
  }

  @override
  int get hashCode => identificador.hashCode;
}
