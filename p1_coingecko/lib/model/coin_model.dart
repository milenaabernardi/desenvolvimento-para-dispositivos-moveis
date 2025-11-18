class Coin {
  final String id;
  final String name;
  final String symbol;
  final String thumbUrl;

  Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.thumbUrl,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      thumbUrl: json['thumb'],
    );
  }
}