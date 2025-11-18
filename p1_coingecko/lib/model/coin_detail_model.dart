class CoinDetail {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final String description;
  final double currentPriceUsd;
  final double priceChangePercentage24h;
  final int marketCapRank;
  final double high24h;
  final double low24h;

  CoinDetail({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.description,
    required this.currentPriceUsd,
    required this.priceChangePercentage24h,
    required this.marketCapRank,
    required this.high24h,
    required this.low24h,
  });

  static String _cleanDescription(String htmlDescription) {
    if (htmlDescription.isEmpty) return "Nenhuma descrição disponível.";
    return htmlDescription.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  factory CoinDetail.fromJson(Map<String, dynamic> json) {
    final marketData = json['market_data'];
    final descriptionData = json['description'];

    // Tenta pegar a descrição em PT
    String descPt = descriptionData['pt'] ?? "";
    
    // Tenta pegar a descrição em EN
    String descEn = descriptionData['en'] ?? "";

    // Se PT não for vazia, usa PT. Senão, tenta usar EN.
    String finalDescription = descPt.isNotEmpty ? descPt : descEn;

    return CoinDetail(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      imageUrl: json['image']['large'],
      description: _cleanDescription(finalDescription),
      
      currentPriceUsd: (marketData['current_price']['usd'] ?? 0).toDouble(),
      priceChangePercentage24h: (marketData['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCapRank: json['market_cap_rank'] ?? 0,
      high24h: (marketData['high_24h']['usd'] ?? 0).toDouble(),
      low24h: (marketData['low_24h']['usd'] ?? 0).toDouble(),
    );
  }
}