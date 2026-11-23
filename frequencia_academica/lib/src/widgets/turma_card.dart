import 'package:flutter/material.dart';

import '../../model/turma.dart';

class TurmaCard extends StatelessWidget {
  final Turma turma;
  final VoidCallback onTap;

  const TurmaCard({
    required this.turma,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.groups)),
        title: Text(turma.identificador),
        subtitle: Text('${turma.quantidadeAlunos} estudantes'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
