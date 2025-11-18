import 'package:flutter/material.dart';
import '../model/coin_model.dart';
import '../repository/coin_repository.dart';

class CoinController extends ChangeNotifier {
  
  final CoinRepository _repository = CoinRepository();

  // --- Estados da Tela ---
  bool _isLoading = false;
  String? _errorMessage;
  
  // Duas listas: uma para o padrão (trending) e uma para busca
  List<Coin> _trendingCoins = [];
  List<Coin> _searchResults = [];

  // String para saber o que o usuário digitou
  String _currentQuery = "";

  // Construtor 
  CoinController() {
    fetchTrendingCoins();
  }

  // Getters públicos
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentQuery => _currentQuery;

  List<Coin> get displayList {
    if (_currentQuery.isEmpty) {
      return _trendingCoins;
    } else {
      return _searchResults; 
    }
  }

  // Busca as moedas em alta
  Future<void> fetchTrendingCoins() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _trendingCoins = await _repository.getTrendingCoins();
    } catch (e) {
      _errorMessage = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }

  // Faz a busca do usuário
  Future<void> performSearch(String query) async {
    _currentQuery = query;

    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _repository.searchCoin(query);
    } catch (e) {
      _errorMessage = e.toString();
      _searchResults = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Limpa a busca e volta para a lista "trending"
  void clearSearch() {
    _currentQuery = "";
    _searchResults = [];
    notifyListeners();
  }
}