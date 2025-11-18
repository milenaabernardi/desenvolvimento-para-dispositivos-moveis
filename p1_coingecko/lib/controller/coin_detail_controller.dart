import 'package:flutter/material.dart';
import '../model/coin_detail_model.dart';
import '../repository/coin_repository.dart';

class CoinDetailController extends ChangeNotifier {
  final CoinRepository _repository = CoinRepository();

  // Estados da Tela de Detalhe
  bool _isLoading = true;
  CoinDetail? _coinDetail;
  String? _errorMessage;

  // Getters públicos
  bool get isLoading => _isLoading;
  CoinDetail? get coinDetail => _coinDetail;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCoinDetails(String coinId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); 

    try {
      _coinDetail = await _repository.getCoinDetails(coinId);
    } catch (e) {
      _errorMessage = e.toString();
    }
    
    _isLoading = false;
    notifyListeners(); 
  }
}