import 'package:flutter/material.dart';

import '../../model/turma.dart';
import '../../repositories/api_frequencia_repository.dart';

class RegistroPresenca extends StatefulWidget {
  final Turma turma;
  final ApiFrequenciaRepository repositorio;

  const RegistroPresenca({
    required this.turma,
    required this.repositorio,
    super.key,
  });

  @override
  State<RegistroPresenca> createState() => _RegistroPresencaState();
}

class _RegistroPresencaState extends State<RegistroPresenca> {
  final Set<int> _faltosos = {};
  final ScrollController _scrollController = ScrollController();
  bool _salvando = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    setState(() => _salvando = true);

    try {
      await widget.repositorio.registrarFaltas(
        widget.turma.identificador,
        _faltosos.toList(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_faltosos.length} faltas registradas')),
      );
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
      appBar: AppBar(
        title: Text(widget.turma.identificador),
        actions: [
          IconButton(
            tooltip: 'Salvar faltas',
            onPressed: _salvando ? null : _salvar,
            icon: _salvando
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.turma.quantidadeAlunos} estudantes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${_faltosos.length} faltosos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.turma.alunos.isEmpty
                ? const Center(child: Text('Esta turma não possui estudantes.'))
                : Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      cacheExtent: 600,
                      itemCount: widget.turma.alunos.length,
                      itemBuilder: (context, index) {
                        final estudante = widget.turma.alunos[index];
                        final faltoso = _faltosos.contains(estudante.id);

                        return CheckboxListTile(
                          value: faltoso,
                          title: Text(estudante.nome),
                          subtitle: Text(
                            'ID: ${estudante.id} • ${estudante.faltas} faltas • ${estudante.presenca} presenças',
                          ),
                          secondary: const CircleAvatar(child: Icon(Icons.person)),
                          onChanged: (valor) {
                            setState(() {
                              if (valor == true) {
                                _faltosos.add(estudante.id);
                              } else {
                                _faltosos.remove(estudante.id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
