import 'package:flutter/material.dart';
import '../../model/estudante.dart';
import '../../model/turma.dart';

class BuscaTurmas extends StatefulWidget {
  final Future<List<Turma>> Function(String consulta, int pagina)? buscarTurmas;

  const BuscaTurmas({this.buscarTurmas, super.key});

  @override
  State<BuscaTurmas> createState() => _BuscaTurmasState();
}

class _BuscaTurmasState extends State<BuscaTurmas> {
  final TextEditingController _buscaController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Turma> _turmas = [];

  bool _carregando = false;
  bool _existeProximaPagina = true;
  int _pagina = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_observarRolagem);
  }

  void _observarRolagem() {
    if (!_scrollController.hasClients || _carregando || !_existeProximaPagina) {
      return;
    }

    final posicao = _scrollController.position;
    const distanciaParaCarregar = 300.0;

    if (posicao.pixels >= posicao.maxScrollExtent - distanciaParaCarregar) {
      _carregarProximaPagina();
    }
  }

  Future<void> _novaBusca() async {
    if (widget.buscarTurmas == null) return;

    setState(() {
      _turmas.clear();
      _pagina = 1;
      _existeProximaPagina = true;
    });

    await _carregarProximaPagina();
  }

  Future<void> _carregarProximaPagina() async {
    final buscar = widget.buscarTurmas;
    if (buscar == null || _carregando || !_existeProximaPagina) return;

    setState(() => _carregando = true);

    try {
      final novosItens = await buscar(_buscaController.text.trim(), _pagina);

      if (!mounted) return;

      setState(() {
        _turmas.addAll(novosItens);
        _pagina++;
        _existeProximaPagina = novosItens.isNotEmpty;
      });
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_observarRolagem);
    _scrollController.dispose();
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
                hintText: 'Ex.: DSDM 2026',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _novaBusca(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _turmas.isEmpty && !_carregando
                  ? const Center(child: Text('Nenhuma turma encontrada.'))
                  : Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _scrollController,
                        cacheExtent: 600,
                        itemCount: _turmas.length + (_carregando ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _turmas.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final turma = _turmas[index];
                          return Card(
                            child: ListTile(
                              leading: const CircleAvatar(child: Icon(Icons.groups)),
                              title: Text(turma.identificador),
                              subtitle: Text('${turma.quantidadeAlunos} estudantes'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RegistroPresenca(turma: turma),
                                  ),
                                );
                              },
                            ),
                          );
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

class BuscaEstudantes extends StatefulWidget {
  final Future<List<Estudante>> Function(String consulta, int pagina)? buscarEstudantes;

  const BuscaEstudantes({this.buscarEstudantes, super.key});

  @override
  State<BuscaEstudantes> createState() => _BuscaEstudantesState();
}

class _BuscaEstudantesState extends State<BuscaEstudantes> {
  final TextEditingController _buscaController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Estudante> _estudantes = [];

  bool _carregando = false;
  bool _existeProximaPagina = true;
  int _pagina = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_observarRolagem);
  }

  void _observarRolagem() {
    if (!_scrollController.hasClients || _carregando || !_existeProximaPagina) {
      return;
    }

    final posicao = _scrollController.position;
    if (posicao.pixels >= posicao.maxScrollExtent - 300) {
      _carregarProximaPagina();
    }
  }

  Future<void> _novaBusca() async {
    if (widget.buscarEstudantes == null) return;

    setState(() {
      _estudantes.clear();
      _pagina = 1;
      _existeProximaPagina = true;
    });

    await _carregarProximaPagina();
  }

  Future<void> _carregarProximaPagina() async {
    final buscar = widget.buscarEstudantes;
    if (buscar == null || _carregando || !_existeProximaPagina) return;

    setState(() => _carregando = true);

    try {
      final novosItens = await buscar(_buscaController.text.trim(), _pagina);

      if (!mounted) return;

      setState(() {
        _estudantes.addAll(novosItens);
        _pagina++;
        _existeProximaPagina = novosItens.isNotEmpty;
      });
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_observarRolagem);
    _scrollController.dispose();
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
              onSubmitted: (_) => _novaBusca(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _estudantes.isEmpty && !_carregando
                  ? const Center(child: Text('Nenhum estudante encontrado.'))
                  : Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _scrollController,
                        cacheExtent: 600,
                        itemCount: _estudantes.length + (_carregando ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _estudantes.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final estudante = _estudantes[index];
                          return Card(
                            child: ListTile(
                              leading: const CircleAvatar(child: Icon(Icons.person)),
                              title: Text(estudante.nome),
                              subtitle: Text(
                                'ID: ${estudante.id} • Turma: ${estudante.turma}',
                              ),
                              trailing: Text('${estudante.presenca} presenças'),
                            ),
                          );
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

class RegistroPresenca extends StatefulWidget {
  final Turma turma;

  const RegistroPresenca({required this.turma, super.key});

  @override
  State<RegistroPresenca> createState() => _RegistroPresencaState();
}

class _RegistroPresencaState extends State<RegistroPresenca> {
  final Set<int> _presentes = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.turma.identificador),
        actions: [
          IconButton(
            tooltip: 'Salvar presença',
            icon: const Icon(Icons.save),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_presentes.length} estudantes selecionados'),
                ),
              );
            },
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
                  '${_presentes.length} presentes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.turma.alunos.isEmpty
                ? const Center(child: Text('Esta turma ainda não possui estudantes.'))
                : Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      cacheExtent: 600,
                      itemCount: widget.turma.alunos.length,
                      itemBuilder: (context, index) {
                        final estudante = widget.turma.alunos[index];
                        final presente = _presentes.contains(estudante.id);

                        return CheckboxListTile(
                          value: presente,
                          title: Text(estudante.nome),
                          subtitle: Text(
                            'ID: ${estudante.id} • Presenças: ${estudante.presenca}',
                          ),
                          secondary: const CircleAvatar(child: Icon(Icons.person)),
                          onChanged: (valor) {
                            setState(() {
                              if (valor == true) {
                                _presentes.add(estudante.id);
                              } else {
                                _presentes.remove(estudante.id);
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