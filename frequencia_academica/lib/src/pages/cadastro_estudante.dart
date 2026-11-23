import 'package:flutter/material.dart';

import '../../model/turma.dart';
import '../../repositories/api_frequencia_repository.dart';

class CadastroEstudante extends StatefulWidget {
  final ApiFrequenciaRepository repositorio;

  const CadastroEstudante({required this.repositorio, super.key});

  @override
  State<CadastroEstudante> createState() => _CadastroEstudanteState();
}

class _CadastroEstudanteState extends State<CadastroEstudante> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idController = TextEditingController();
  final _idadeController = TextEditingController();
  Turma? _turmaSelecionada;
  bool _salvando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _idController.dispose();
    _idadeController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _salvando = true);

    try {
      await widget.repositorio.cadastrarEstudante(
        nome: _nomeController.text.trim(),
        id: int.parse(_idController.text.trim()),
        idade: int.parse(_idadeController.text.trim()),
        turma: _turmaSelecionada!.identificador,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estudante cadastrado com sucesso')),
      );
      _nomeController.clear();
      _idController.clear();
      _idadeController.clear();
      setState(() => _turmaSelecionada = null);
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar estudante')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) => valor == null || valor.trim().isEmpty
                    ? 'Informe o nome'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || int.tryParse(valor) == null) {
                    return 'Informe um ID numérico';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || int.tryParse(valor) == null) {
                    return 'Informe uma idade numérica';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Turma>>(
                future: widget.repositorio.listarTurmas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhuma turma disponível');
                  }

                  final turmas = snapshot.data!;

                  return DropdownButtonFormField<Turma>(
                    initialValue: _turmaSelecionada,
                    decoration: const InputDecoration(
                      labelText: 'Turma',
                      prefixIcon: Icon(Icons.groups),
                      border: OutlineInputBorder(),
                    ),
                    items: turmas
                        .map((turma) => DropdownMenuItem<Turma>(
                              value: turma,
                              child: Text(turma.identificador),
                            ))
                        .toList(),
                    onChanged: (turma) {
                      setState(() => _turmaSelecionada = turma);
                    },
                    validator: (turma) =>
                        turma == null ? 'Selecione uma turma' : null,
                  );
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _salvando ? null : _cadastrar,
                icon: _salvando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.person_add),
                label: const Text('Cadastrar estudante'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
