class Estudante {
  final int id;
  final String nome;
  final int idade;
  final String turma;
  int presenca;
  int faltas;

  Estudante({
    required this.id,
    required this.nome,
    required this.idade,
    required this.turma,
    this.presenca = 0,
    this.faltas = 0,
  });

  factory Estudante.fromJson(Map<String, dynamic> json) {
    return Estudante(
      id: json['id'] as int,
      nome: json['nome'] as String,
      idade: json['idade'] as int,
      turma: json['turma']?.toString() ?? '',
      presenca: json['presenca'] as int? ?? 0,
      faltas: json['faltas'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'turma': turma,
      'presenca': presenca,
      'faltas': faltas,
    };
  }
}
