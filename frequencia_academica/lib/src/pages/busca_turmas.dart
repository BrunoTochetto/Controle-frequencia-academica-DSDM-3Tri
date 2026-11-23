import 'package:flutter/material.dart';

import '../../model/turma.dart';
import '../../repositories/api_frequencia_repository.dart';
import '../widgets/lista_paginada.dart';
import '../widgets/turma_card.dart';
import 'registro_presenca.dart';

class BuscaTurmas extends StatefulWidget {
  final ApiFrequenciaRepository repositorio;

  const BuscaTurmas({required this.repositorio, super.key});

  @override
  State<BuscaTurmas> createState() => _BuscaTurmasState();
}

class _BuscaTurmasState extends State<BuscaTurmas> {
  final TextEditingController _buscaController = TextEditingController();
  final GlobalKey<ListaPaginadaState<Turma>> _listaKey =
      GlobalKey<ListaPaginadaState<Turma>>();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar turma')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _buscaController,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                labelText: 'Identificador da turma',
                hintText: 'Ex.: DSDM',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _listaKey.currentState?.novaBusca(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListaPaginada<Turma>(
                key: _listaKey,
                paginador: (consulta, pagina) =>
                    widget.repositorio.buscarTurmas(
                  consulta: consulta,
                  pagina: pagina,
                ),
                consultaVazia: 'Nenhuma turma encontrada.',
                buscaController: _buscaController,
                itemBuilder: (context, turma) => TurmaCard(
                  turma: turma,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegistroPresenca(
                          turma: turma,
                          repositorio: widget.repositorio,
                        ),
                      ),
                    );
                    await _listaKey.currentState?.novaBusca();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
