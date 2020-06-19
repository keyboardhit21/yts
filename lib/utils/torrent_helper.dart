import '../models/torrent.dart';

class TorrentHelper {

  List<dynamic> getList(List<dynamic> torrentResponse) {
    List<Torrent> list = torrentResponse.map((item) => Torrent.fromJson(item)).toList();
    return list;
  }
  
}