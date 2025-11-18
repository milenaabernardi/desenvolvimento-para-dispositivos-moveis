import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/coin_model.dart';
import '../model/coin_detail_model.dart';

class CoinRepository {
  
  final String _apiKey = dotenv.env['COIN_GECKO_KEY'] ?? ""; 
  
  final String _baseUrl = "https://api.coingecko.com/api/v3";

  // BUSCAR MOEDAS (Search)
  Future<List<Coin>> searchCoin(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final Uri url = Uri.parse('$_baseUrl/search?query=$query&x_cg_demo_api_key=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> coinList = data['coins'];
        return coinList.map((json) => Coin.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar ($query): ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na busca: $e');
    }
  }

  // MOEDAS EM ALTA (Trending)
  Future<List<Coin>> getTrendingCoins() async {
    final Uri url = Uri.parse('$_baseUrl/search/trending?x_cg_demo_api_key=$_apiKey');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> coinList = data['coins'];
        return coinList.map((json) => Coin.fromJson(json['item'])).toList();
      } else {
        throw Exception('Falha ao carregar trending: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar moedas em alta: $e');
    }
  }

  // DETALHES DA MOEDA
  Future<CoinDetail> getCoinDetails(String coinId) async {
    final Uri url = Uri.parse(
      '$_baseUrl/coins/$coinId?market_data=true&localization=true&sparkline=false&x_cg_demo_api_key=$_apiKey'
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CoinDetail.fromJson(data);
      } else {
        throw Exception('Falha ao carregar detalhes ($coinId): ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar detalhes: $e');
    }
  }
}