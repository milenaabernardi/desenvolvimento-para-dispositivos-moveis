import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class InvertextoService {
  final String _token = "21600|PMDZQSmQ5ZBnszyFpPL5ZK683gwJdLXh";

  Future<Map<String, dynamic>> convertePorExtenso(String? valor) async {
    try {
      final uri = Uri.parse("https://api.invertexto.com/v1/number-to-words?token=$_token&number=$valor&language=pt&currency=BRL");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode} : ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buscaCep(String? valor) async {
    try {
      final uri = Uri.parse("https://api.invertexto.com/v1/cep/$valor?token=$_token");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode} : ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> validaEmail(String email) async {
    try {
      final url = Uri.parse('https://api.invertexto.com/v1/email-validator/$email?token=$_token');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode} : ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }
}