
class Torrent {

  String url;
  String quality;
  String type;
  String size;

  Torrent(this.url, this.quality, this.type, this.size);

  Torrent.fromJson(Map<String, dynamic> item) {
    this.url = item['url'];
    this.quality = item['quality'];
    this.type = item['type'];
    this.size = item['size'];
  }
  

}