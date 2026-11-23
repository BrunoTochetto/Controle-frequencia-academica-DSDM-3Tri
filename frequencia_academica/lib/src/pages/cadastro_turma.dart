import 'package:flutter/material.dart';

import '../../repositories/api_frequencia_repository.dart';

class CadastroTurma extends StatefulWidget {
  final ApiFrequenciaRepository repositorio;

  const CadastroTurma({required this.repositorio, super.key});

  @override
  State<CadastroTurma> createState() => _CadastroTurmaState();
}

class _CadastroTurmaState extends State<CadastroTurma> {
  final _formKey = GlobalKey<FormState>();
  final _identificadorController = TextEditingController();
  bool _salvando = false;

  @override
  void dispose() {
    _identificadorController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _salvando = true);

    try {
      await widget.repositorio.cadastrarTurma(
        _identificadorController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Turma cadastrada com sucesso')),
      );
      _identificadorController.clear();
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
      appBar: AppBar(title: const Text('Cadastrar turma')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _identificadorController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Identificador da turma',
                  hintText: 'Ex.: DSDM 3º Tri',
                  prefixIcon: Icon(Icons.groups),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o identificador da turma';
                  }
                  return null;
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
                    : const Icon(Icons.save),
                label: const Text('Cadastrar turma'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
