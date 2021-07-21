import 'package:flutter/material.dart';
import 'classes/Mixin.dart';
import 'classes/songsData.dart';
import 'repository/database.dart';
import 'classes/audioPlayerController.dart';

class FavoritePage extends StatefulWidget {
  createState() {
    return FavoritePageState();
  }
}

class FavoritePageState extends State<FavoritePage> with Functions{
  Future<List<Songs>> savedSongs;

  initState() {
    super.initState();
    refreshList();
  }

  refreshList() {
    setState(() {
      savedSongs=dbHelper.getSongs();
    });
  }

  Widget build(context) {
    var screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder(
        stream: audioC.outPlayer,
        builder: (context, AsyncSnapshot snapshot) {
          return Container(
            width: screenSize.width,
            height: 0.94*screenSize.height,
            padding: EdgeInsets.fromLTRB(15.0, 70.0, 15.0, 0.0),
            //color: Colors.red,
            child: Column(
              children: [
                //word of Favorites
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Favorites:',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold)),
                ),
                //split Container between two containers
                Container(
                  height: 0.0003*screenSize.height,
                  width: 0.8*screenSize.width,
                  margin: EdgeInsets.only(top: 23.0),
                  color: Colors.purple,
                ),
                //the Container of the songs favorite
                Container(
                  //color: Colors.green,
                  width: screenSize.width,
                  height: 0.764*screenSize.height,
                  child: FutureBuilder(
                    future: savedSongs,
                    builder: (context,snapshot) {
                      if(null==snapshot.data || snapshot.data.length==0) {
                        audioC.player.listLength=favList.length;
                        return Center(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('background.png',
                                height: 450.0,
                                width: 300.0,
                                ),
                                Text('start adding your favorites',style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                          itemCount: favList.length,
                          itemBuilder: (context,int index) {
                            final item=favList[index].title;
                            return Dismissible(
                              key: Key(item), 
                              onDismissed: (direction) {
                                swipeItem(item);
                              },
                              background: Container(
                                padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                                alignment: AlignmentDirectional.centerStart,
                                color:Colors.white,
                                child: Icon(Icons.delete,color:Colors.purple[400]),
                              ),
                              child: Card(
                                shadowColor: Colors.purple,
                                elevation: 0.5,
                                child: ListTile(
                                  title: Text(favList[index].title,style: TextStyle(fontSize: 20.0)),
                                  subtitle: Text(favList[index].subtitle),
                                  trailing: IconButton(
                                    icon: playButton(favList[index].url+'.mp3'),
                                    onPressed: () {
                                      if(audioC.player.musicaAtual==favList[index].url+'.mp3') {
                                        audioC.buttonPlayPause();
                                      }
                                      else {
                                        audioC.addMusic(favList[index].url+'.mp3', index);
                                      }
                                    }, 
                                  ),
                                  onTap: () {
                                    if(audioC.player.musicaAtual==favList[index].url+'.mp3') {
                                      audioC.buttonPlayPause();
                                    }
                                    else {
                                      audioC.addMusic(favList[index].url+'.mp3',index);
                                      audioC.player.playList=favList;
                                    }
                                    audioC.player.listLength=favList.length;
                                    playingList='favorites';
                                    singerName=favList[index].subtitle;
                                  },
                                ),
                              ),
                            ); 
                          },
                      );
                    },
                  ), 
                ),
              ],
            ),
          );
        },
      ), 
    );
  }
  Widget playButton(String title) {
    return Icon(audioC.player.musicaAtual==title && audioC.player.play? Icons.pause: Icons.play_arrow,size: 28.0,color: Colors.purple[400],);
  }
}