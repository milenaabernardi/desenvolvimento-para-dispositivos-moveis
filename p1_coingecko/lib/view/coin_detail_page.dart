import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_digit/animated_digit.dart';
import '../controller/coin_detail_controller.dart';
import 'widgets/price_chart.dart';

class CoinDetailPage extends StatefulWidget {
  final String coinId;
  final String coinName;

  const CoinDetailPage({
    super.key, 
    required this.coinId, 
    required this.coinName
  });

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  // Variável para controlar o estado visual do botão de favoritar (apenas visual)
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CoinDetailController>(context, listen: false)
          .fetchCoinDetails(widget.coinId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B12),
      body: Consumer<CoinDetailController>(
        builder: (context, controller, child) {
          
          // Loading
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFBB86FC)));
          }

          // Erro
          if (controller.errorMessage != null) {
            return Center(child: Text('Erro: ${controller.errorMessage}'));
          }

          // Sem dados
          if (controller.coinDetail == null) return const SizedBox.shrink();
          
          final detail = controller.coinDetail!;
          final isPositive = detail.priceChangePercentage24h >= 0;
          final changeColor = isPositive ? const Color(0xFF00FFA3) : const Color(0xFFFF5555);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF0B0B12),
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? const Color(0xFFBB86FC) : Colors.white,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isFavorite 
                                ? "${detail.name} adicionado aos favoritos!" 
                                : "${detail.name} removido dos favoritos.",
                              style: GoogleFonts.inter(color: Colors.white),
                            ),
                            backgroundColor: const Color(0xFF1E1E2C),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    widget.coinName,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  background: Center(
                    child: Hero(
                      tag: detail.id,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Image.network(detail.imageUrl, height: 120, width: 120),
                      ),
                    ),
                  ),
                ),
              ),

              // CONTEÚDO DA PÁGINA
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      AnimatedDigitWidget(
                        value: detail.currentPriceUsd,
                        prefix: '\$',
                        fractionDigits: 2,
                        textStyle: GoogleFonts.robotoMono(
                          fontSize: 40,
                          fontWeight: FontWeight.bold, 
                          color: Colors.white
                        ),
                      ),
                      
                      // BADGE DE VARIAÇÃO
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: changeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: changeColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          '${isPositive ? '▲' : '▼'} ${detail.priceChangePercentage24h.toStringAsFixed(2)}%',
                          style: TextStyle(color: changeColor, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // GRÁFICO
                      PriceChart(
                        minPrice: detail.low24h,
                        maxPrice: detail.high24h,
                        currentPrice: detail.currentPriceUsd,
                        isPositive: isPositive,
                      ),

                      const SizedBox(height: 40),

                      // GRID DE ESTATÍSTICAS
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                        children: [
                          _buildGlassStatCard('Rank Global', '#${detail.marketCapRank}', Icons.emoji_events),
                          _buildGlassStatCard('Máxima 24h', '\$${detail.high24h}', Icons.north_east),
                          _buildGlassStatCard('Mínima 24h', '\$${detail.low24h}', Icons.south_west),
                          _buildGlassStatCard('Símbolo', detail.symbol.toUpperCase(), Icons.token),
                        ],
                      ),

                      const SizedBox(height: 40),
                      
                      // DESCRIÇÃO
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sobre ${detail.name}', 
                          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Text(
                          detail.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8), 
                            height: 1.6,
                            fontSize: 16
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Card auxiliar
  Widget _buildGlassStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFBB86FC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFBB86FC), size: 20),
          ),
          const Spacer(),
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        ],
      ),
    );
  }
}