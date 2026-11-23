import 'package:flutter/material.dart';

import '../../model/estudante.dart';

class EstudanteTile extends StatelessWidget {
  final Estudante estudante;

  const EstudanteTile({required this.estudante, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(estudante.nome),
        subtitle: Text('ID: ${estudante.id} • Turma: ${estudante.turma}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${estudante.presenca} presenças'),
            Text('${estudante.faltas} faltas'),
          ],
        ),
      ),
    );
  }
}
