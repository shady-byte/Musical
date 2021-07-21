import 'package:flutter/material.dart';
import 'classes/audioPlayerController.dart';
import 'classes/Mixin.dart';
import 'classes/songsData.dart';
import 'repository/database.dart';
import 'classes/audioPlayer.dart';

class FavoriteScreen extends StatefulWidget {
  createState() {
    return FavoriteState();
  }
}

class FavoriteState extends State<FavoriteScreen> with Functions{
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
        builder: (context, AsyncSnapshot<Player> snapshot) {
          return Column(
        children: [
          //The Headline of the App
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 20.0,0.0,0.0),
            padding: EdgeInsets.only(top:40.0,left: 15.0),
            height: 0.112*screenSize.height,
            width: screenSize.width,
            //color: Colors.green,
            child: Text(
              'Explore:',
              style: TextStyle(fontSize: 27.0,fontWeight: FontWeight.bold),
            ),
          ),
          //The List of Artists in the App
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0,0.0),
            height: 0.18*screenSize.height,
            width: screenSize.width,
            //color: Colors.grey,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: singers.length,
              itemBuilder: (context,int index) {
                String photo= singers[index].replaceAll(new RegExp(r"\s+"), "");
                return Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        height: 0.25*screenSize.width,
                        width: 0.25*screenSize.width,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          //color:Colors.green,
                          image: DecorationImage(
                            image: AssetImage(photo+'.jpg'),
                            fit: BoxFit.fill, 
                          ),
                        ),
                      ),
                      onTap: () {
                        artistName=singers[index];
                        Navigator.pushNamed(context,'-favorites');
                      },
                    ),
                    
                    Text(singers[index]),
                  ],
                ); 
              },
            ),
          ),
          //the Second Text Favorites Word
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0,0.0,0.0),
            padding: EdgeInsets.only(top:40.0,left: 15.0,right: 15.0),
            height: 0.104*screenSize.height,
            width: screenSize.width,
            //color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Favorites',
                  style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.refresh,size: 30.0,color: Colors.purple[400],),
                  onPressed: () {
                    setState(() {
                      savedSongs= dbHelper.getSongs();
                    });
                    
                  }
                ),
              ],
            ),
          ),
          //The Favorites List of Songs 
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0,0.0,0.0),
            padding: EdgeInsets.only(top:0.0,left: 15.0,right: 15.0),
            height: 0.503*screenSize.height,
            width: screenSize.width,
            //color: Colors.blue,
            child: FutureBuilder(
              future: savedSongs,
              builder: (context, AsyncSnapshot snapshot) {
                return buildingFav(snapshot.data);
              },
            ),
          ),
        ],
      ); 
        },
      ), 
    );
  }
  Widget buildingFav(List<Songs> x) {
    if(null==x || x.length==0) {
      return Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('background.png',
              height: 300.0,
              width: 270.0,
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
  }

  Widget playButton(String title) {
    return Icon(audioC.player.musicaAtual==title && audioC.player.play? Icons.pause: Icons.play_arrow,size: 28.0,color: Colors.purple[400],);
  }
}