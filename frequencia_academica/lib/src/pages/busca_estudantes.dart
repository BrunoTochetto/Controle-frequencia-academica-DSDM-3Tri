import 'package:flutter/material.dart';

import '../../model/estudante.dart';
import '../../repositories/api_frequencia_repository.dart';
import '../widgets/estudante_tile.dart';
import '../widgets/lista_paginada.dart';

class BuscaEstudantes extends StatefulWidget {
  final ApiFrequenciaRepository repositorio;

  const BuscaEstudantes({required this.repositorio, super.key});

  @override
  State<BuscaEstudantes> createState() => _BuscaEstudantesState();
}

class _BuscaEstudantesState extends State<BuscaEstudantes> {
  final TextEditingController _buscaController = TextEditingController();
  final GlobalKey<ListaPaginadaState<Estudante>> _listaKey =
      GlobalKey<ListaPaginadaState<Estudante>>();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar estudante')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _buscaController,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                labelText: 'Nome ou ID do estudante',
                prefixIcon: Icon(Icons.person_search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _listaKey.currentState?.novaBusca(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListaPaginada<Estudante>(
                key: _listaKey,
                paginador: (consulta, pagina) =>
                    widget.repositorio.buscarEstudantes(
                  consulta: consulta,
                  pagina: pagina,
                ),
                consultaVazia: 'Nenhum estudante encontrado.',
                buscaController: _buscaController,
                itemBuilder: (context, estudante) =>
                    EstudanteTile(estudante: estudante),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
