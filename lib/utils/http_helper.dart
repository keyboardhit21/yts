
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/parameter.dart';

class HttpHelper {

  final String url = "https://yts.mx/api/v2/list_movies.json";


  Future<String> getList(String page) async {
    http.Response response = await http.get(url + '?page=' + page);
    if(response.statusCode == HttpStatus.ok) {
      String body = response.body;
      return body.toString();
    }
    return '';
  }

  Future<String> getSearch(List<Parameter> parameters, String page) async {
    String parameterList = '';
    parameters.forEach((element) {
      parameterList += '&' + element.name + '=' + element.value;
    });
    http.Response response = await http.get(url + '?' + parameterList + '&page=' + page);
    if(response.statusCode == HttpStatus.ok) {
      String body = response.body;
      return body.toString();
    }
    return '';
  }

  

}