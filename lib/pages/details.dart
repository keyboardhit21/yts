import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/torrent.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../models/parameter.dart';
import './search.dart';


class Details extends StatefulWidget {

  final Movie movie;
  final List<Torrent> torrent;

  Details(this.movie, this.torrent);

  @override
  _DetailsState createState() => _DetailsState(this.movie, this.torrent);

}

class _DetailsState extends State<Details> {

  final Movie movie;
  final List<Torrent> torrent;
  Dio dio;
  GlobalKey _key = GlobalKey();
  


  _DetailsState(this.movie, this.torrent);

  @override
  void initState() {
    super.initState();
    dio = new Dio();
  }

  @override
  Widget build(BuildContext context) {
    print(this.movie.genre.length.toString() + ' This is the length');
    return Scaffold(
      backgroundColor: Colors.black,
      key: _key,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(this.movie.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                          ),
                        ),
                      ),      
                      Positioned(
                        top: 160,
                        left: 20,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/no-image.png', 
                          image: this.movie.image,
                          width: 100,
                        ),
                      ),
                      Positioned(
                        right: 25,
                        top: 180,
                        child: Container(
                          width: 170.0,
                          child: Text(
                            this.movie.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green[50],
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 315,
                        left: 45,
                        child: Text(
                          '(' + this.movie.year + ')',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                        )
                      )       
                    ],
                  ),
                SizedBox(
                  height: 100.0,
                ),
                Wrap(
                  children: List.generate((this.movie.genre.length != null) ? this.movie.genre.length : 0, (index) {
                    return Container(
                      margin: EdgeInsets.only(left: 2, right: 2),
                      child: InkWell(
                        child: Chip(
                          label: Text(this.movie.genre[index]),
                          backgroundColor: Colors.green,
                        ),
                        onTap: () {
                          List<Parameter> parameter = [Parameter('genre', this.movie.genre[index])];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Search(parameter, '1'),
                            )
                          );
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Summary',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    this.movie.summary,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Column(
                  children: List.generate(this.torrent.length, (index) {
                    return Builder(
                      builder: (context) => ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          child: Text(
                            this.torrent[index].quality + ' (' + this.torrent[index].size + ') ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.green,
                          onPressed: () async {
                            Future<Directory> downloads  =  getExternalStorageDirectory();
                            downloads.then((directory) async {
                              print('Nothing');
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Download Started...'),));
                              await dio.download(
                                this.torrent[index].url, '/storage/emulated/0/Download/${this.movie.title}.torrent',
                              );
                            });     
                          },
                        )
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Note: This only downloads the torrent file. After the "Download Started" notifier, check the Download folder of your device. You should have a Torrent Client installed to download it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}