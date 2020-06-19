import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yts/models/parameter.dart';
import '../utils/http_helper.dart';
import '../utils/movie_helper.dart';
import '../models/movie.dart';
import '../utils/torrent_helper.dart';
import '../models/torrent.dart';
import './details.dart';
import './search.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final httpHelper = HttpHelper();
  final movieHelper = MovieHelper();
  final torrentHelper = TorrentHelper();
  TextEditingController _controller = TextEditingController();
  String page = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Latest Torrents'),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20.0, top: 20.0,),
            child: Text(
              'page ' + this.page,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          if(direction == DismissDirection.startToEnd) {
            int page = (int.parse(this.page) <= 1) ? 1 : (int.parse(this.page) - 1); 
            setState(() {
              this.page = page.toString();
            });
          }
          if(direction == DismissDirection.endToStart) {
            setState(() {
              this.page = (int.parse(this.page) + 1).toString();
            });
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: FutureBuilder(
              future: httpHelper.getList(page),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                String response = snapshot.data;
                if(!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                List<Movie> movies = movieHelper.getList(response);

                if(movies.isNotEmpty) {
                    return ListView.builder(
                    itemCount: (movies.length != null) ? movies.length : 0,
                    itemBuilder: (BuildContext context, int position) {

                      List<Torrent> torrents = torrentHelper.getList(movies[position].torrent);

                      return InkWell(
                        child: Container (
                          margin: EdgeInsets.only(bottom: 25.0),
                          padding: EdgeInsets.all(5.0),
                          alignment: Alignment.topLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              FadeInImage.assetNetwork(
                                placeholder: 'assets/images/no-image.png',
                                image: movies[position].image,
                                width: 100.0,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      movies[position].title,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      )
                                    ),
                                    SizedBox(
                                      height: 10.0
                                    ),
                                    Text(
                                      '(' + movies[position].year + ')',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                      )
                                    ),
                                    SizedBox(
                                      height: 10.0
                                    ),
                                    Text(
                                      'Rating: ' + movies[position].rating,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                      )
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Wrap(
                                      children: List.generate(torrents.length, (index) {
                                        return Container(
                                          margin: EdgeInsets.all(5.0),
                                          child: Chip(
                                            label: Text(
                                              torrents[index].quality,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            backgroundColor: Colors.green,
                                          )
                                        );
                                      }),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Details(movies[position], torrents),
                            )
                          );
                        },
                      );
                    }
                  );
                }
                else {
                  return Center(
                    child: Text(
                      'No Records Found!',
                      style: TextStyle(
                        color: Colors.white,
                      )
                    )
                  );
                }
              },
            )
          )
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/wallpaper.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),  
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              'Search Filters',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search Term',
                ),
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              height: 50.0,
              child: RaisedButton(
                child: Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Search([Parameter('query_term', _controller.text.toString())], '1'),
                    )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}