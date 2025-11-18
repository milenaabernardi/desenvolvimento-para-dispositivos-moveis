import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../controller/coin_controller.dart';
import 'coin_detail_page.dart';
import 'widgets/coin_card.dart';
import 'widgets/shimmer_loading.dart';

class CoinSearchPage extends StatefulWidget {
  const CoinSearchPage({super.key});

  @override
  State<CoinSearchPage> createState() => _CoinSearchPageState();
}

class _CoinSearchPageState extends State<CoinSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() { setState(() {}); });
  }

  void _triggerSearch() {
    final controller = Provider.of<CoinController>(context, listen: false);
    controller.performSearch(_searchController.text);
  }

  void _clearSearch() {
    _searchController.clear();
    final controller = Provider.of<CoinController>(context, listen: false);
    controller.clearSearch();
  }

  Future<void> _refreshData() async {
    final controller = Provider.of<CoinController>(context, listen: false);
    if (_searchController.text.isNotEmpty) {
      await controller.performSearch(_searchController.text);
    } else {
      await controller.fetchTrendingCoins();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CryptoHunter'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // CAMPO DE BUSCA
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar moeda (ex: bitcoin)...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFBB86FC)),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: _clearSearch)
                  : null,
                filled: true,
                fillColor: const Color(0xFF1E1E2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _triggerSearch(),
            ),
            
            const SizedBox(height: 24),

            // TÍTULO DA SEÇÃO
            Align(
              alignment: Alignment.centerLeft,
              child: Consumer<CoinController>(
                builder: (context, controller, _) {
                  return Text(
                    controller.currentQuery.isEmpty ? "🔥 Em Alta" : "🔍 Resultados",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                }
              ),
            ),
            
            const SizedBox(height: 16),

            // CONTEÚDO DA LISTA
            Expanded(
              child: Consumer<CoinController>(
                builder: (context, controller, child) {
                  // Estado de Carregamento (Shimmer)
                  if (controller.isLoading) {
                    return const ShimmerLoading();
                  }

                  // Estado de Erro
                  if (controller.errorMessage != null) {
                    return _buildErrorWidget(controller.errorMessage!, context);
                  }

                  final list = controller.displayList;

                  // Estado de Lista Vazia (LOTTIE)
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animação de "Caixa Vazia"
                          Lottie.network(
                            'https://lottie.host/955e5757-d00d-4d1b-9a11-05344235998b/d8vQY0XqKq.json',
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback caso a internet falhe ao carregar a animação
                              return Icon(Icons.search_off, size: 80, color: Colors.white.withOpacity(0.2));
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            controller.currentQuery.isEmpty 
                              ? 'Carregando mercado...' 
                              : 'Ops! Nenhuma moeda encontrada.',
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  // Lista de Sucesso
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    color: const Color(0xFFBB86FC),
                    backgroundColor: const Color(0xFF1E1E2C),
                    child: ListView.builder(
                      itemCount: list.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final coin = list[index];
                        return CoinCard(
                          coin: coin,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CoinDetailPage(
                                  coinId: coin.id,
                                  coinName: coin.name,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget de Erro Personalizado
  Widget _buildErrorWidget(String error, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Você também pode usar um Lottie de erro aqui se quiser!
          const Icon(Icons.wifi_off, size: 60, color: Color(0xFFFF5555)),
          const SizedBox(height: 16),
          const Text(
            "Algo deu errado",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              error.contains("429") ? "Muitas requisições. Aguarde um momento." : "Verifique sua conexão com a internet.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            label: const Text("Tentar Novamente"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBB86FC),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        ],
      ),
    );
  }
}