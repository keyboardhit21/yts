import 'dart:convert';
import '../models/movie.dart';



class MovieHelper {

  List<dynamic> getList(String httpResponse) {
    final jsonResponse = json.decode(httpResponse);
    final movies = jsonResponse["data"]["movies"];
    try {
      List<Movie> list = (movies as List).map((item) => Movie.fromJson(item)).toList();
      return list;
    }
    catch(e) {
      return List<Movie>();
    }
  }

}