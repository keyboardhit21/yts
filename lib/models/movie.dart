class Movie {

  String id;
  String title;
  String year;
  String rating;
  String summary;
  String image;
  List<dynamic> torrent;
  List<dynamic> genre;

  Movie(this.id, this.title, this.year, this.rating, this.summary, this.image, this.torrent, this.genre);

  Movie.fromJson(Map<String, dynamic> item) {
    this.id = item['id'].toString();
    this.title = item['title'].toString();
    this.year = item['year'].toString();
    this.rating = item['rating'].toString();
    this.summary = item['summary'].toString();
    this.image = item['large_cover_image'];
    this.torrent = item['torrents'];
    this.genre = item['genres'];
  }

}