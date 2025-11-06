import 'dart:convert';
import 'package:http/http.dart' as http;

String _key = "r033plOhG39PQT9MT6Yq5i7xy7vcHxJq";

class GiphyService {

  Future<Map> getGifs(String search, int offset) async{
    http.Response response;
    if(search == null || search.isEmpty){
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=$_key&limit=25&offset=$offset&rating=g&bundle=messaging_non_clips"));
    }else{
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=$_key&q=$search&limit=25&offset=$offset&rating=g&lang=en&bundle=messaging_non_clips"));
    }
    return json.decode(response.body);
  }  
}