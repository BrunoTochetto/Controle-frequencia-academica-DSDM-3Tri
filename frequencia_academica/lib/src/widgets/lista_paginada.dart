import 'package:flutter/material.dart';

typedef Paginador<T> = Future<List<T>> Function(String consulta, int pagina);

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);

class ListaPaginada<T> extends StatefulWidget {
  final Paginador<T> paginador;
  final ItemBuilder<T> itemBuilder;
  final TextEditingController buscaController;
  final String consultaVazia;

  const ListaPaginada({
    required this.paginador,
    required this.itemBuilder,
    required this.buscaController,
    required this.consultaVazia,
    super.key,
  });

  @override
  State<ListaPaginada<T>> createState() => ListaPaginadaState<T>();
}

class ListaPaginadaState<T> extends State<ListaPaginada<T>> {
  final ScrollController _scrollController = ScrollController();
  final List<T> _itens = [];

  bool _carregando = false;
  bool _existeProximaPagina = true;
  int _pagina = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_observarRolagem);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      novaBusca();
    });
  }

  void _observarRolagem() {
    if (!_scrollController.hasClients ||
        _carregando ||
        !_existeProximaPagina) {
      return;
    }

    final posicao = _scrollController.position;
    if (posicao.pixels >= posicao.maxScrollExtent - 300) {
      _carregarProximaPagina();
    }
  }

  Future<void> novaBusca() async {
    setState(() {
      _itens.clear();
      _pagina = 1;
      _existeProximaPagina = true;
    });
    await _carregarProximaPagina();
  }

  Future<void> _carregarProximaPagina() async {
    if (_carregando || !_existeProximaPagina) return;

    setState(() => _carregando = true);

    try {
      final novosItens = await widget.paginador(
        widget.buscaController.text.trim(),
        _pagina,
      );

      if (!mounted) return;

      setState(() {
        _itens.addAll(novosItens);
        _pagina++;
        _existeProximaPagina = novosItens.isNotEmpty;
      });
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_observarRolagem);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_itens.isEmpty && !_carregando) {
      return Center(child: Text(widget.consultaVazia));
    }

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: ListView.builder(
        controller: _scrollController,
        cacheExtent: 600,
        itemCount: _itens.length + (_carregando ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _itens.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return widget.itemBuilder(context, _itens[index]);
        },
      ),
    );
  }
}
