import 'package:flutter/material.dart';

class Inicial extends StatelessWidget {
  const Inicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Frequência'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MenuCard(
              icon: Icons.groups,
              title: 'Buscar turma',
              onTap: () => Navigator.pushNamed(context, '/turmas'),
            ),
            const SizedBox(height: 16),
            _MenuCard(
              icon: Icons.person_search,
              title: 'Buscar estudante',
              onTap: () => Navigator.pushNamed(context, '/estudantes'),
            ),
            const SizedBox(height: 16),
            _MenuCard(
              icon: Icons.group_add,
              title: 'Cadastrar turma',
              onTap: () => Navigator.pushNamed(context, '/cadastrar-turma'),
            ),
            const SizedBox(height: 16),
            _MenuCard(
              icon: Icons.person_add,
              title: 'Cadastrar estudante',
              onTap: () => Navigator.pushNamed(context, '/cadastrar-estudante'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 44),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}