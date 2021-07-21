import 'package:flutter/material.dart';
import 'package:the_music_app/src/classes/Mixin.dart';
import 'package:the_music_app/src/classes/audioPlayerController.dart';
import 'classes/songsData.dart';
import 'classes/audioPlayer.dart';

class Artist extends StatefulWidget {
  createState() {
    return ArtistState();
  }
}

class ArtistState extends State<Artist> with Functions{

  Widget build(context) {
    songsOfArtist();
    var screenSize=MediaQuery.of(context).size;
    return StreamBuilder(
      stream: audioC.outPlayer,
      builder: (context,AsyncSnapshot<Player> snaphot) {
        return Column(
            children: [
              //back button
              //Container of image and name of artist
              Container(
                height: 0.4*screenSize.height,
                width: screenSize.width,
                padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                //color: Colors.blue,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.all(5.1),
                        child: FlatButton.icon(
                          icon: Icon(Icons.arrow_back_ios,size:30.0,color: Colors.purple[400],),
                          label: Text('Back', style: TextStyle(fontSize: 20.0,color: Colors.grey[600],)),
                          onPressed: (){
                            Navigator.pushNamed(context,'/');
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0.0,20.0, 0.0, 20.0),
                        width: 0.4*screenSize.width,
                        height: 0.2*screenSize.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          //color: Colors.green,
                          image: DecorationImage(
                            image: AssetImage(artistName.replaceAll(new RegExp(r"\s+"), "")+'.jpg'),
                            fit: BoxFit.fill
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(artistName, style: TextStyle(fontSize: 27.0,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
            //Container the line splits the 2 widgets
            Container(
              height: 0.0003*screenSize.height,
              width: 0.8*screenSize.width,
              margin: EdgeInsets.only(top: 10.0),
              color: Colors.purple,
            ),
            //Container of Songs of artist
            Container(
              height: 0.51*screenSize.height,
              width: screenSize.width,
              padding: EdgeInsets.only(top:0.0,left: 10.0,right: 10.0),
              //color: Colors.red,
              child: ListView.builder(
                itemCount: listOfArtist.length,
                itemBuilder: (context,int index) {
                  return Card(
                    shadowColor: Colors.purple,
                    elevation: 0.5,
                    child: ListTile(
                      title: Text(listOfArtist[index].title,style: TextStyle(fontSize: 20.0)),
                      subtitle: Text(listOfArtist[index].subtitle),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: playButton(listOfArtist[index].url+'.mp3'),
                            onPressed: () {
                              if(audioC.player.musicaAtual==listOfArtist[index].url+'.mp3') {
                                audioC.buttonPlayPause();
                              }
                              else {
                                audioC.addMusic(listOfArtist[index].url+'.mp3', index);
                              }
                            },
                          ),
                          IconButton(
                            icon: favoriteButton(index),
                            onPressed: () {
                              setState(() {
                                checkFavButton(index);
                              });
                            }, 
                          ), 
                        ],
                      ), 
                      
                      onTap: () {
                        if(audioC.player.musicaAtual==listOfArtist[index].url+'.mp3') {
                          audioC.buttonPlayPause();
                        }
                        else {
                          audioC.addMusic(listOfArtist[index].url+'.mp3',index);
                          audioC.player.playList=listOfArtist;
                          singerName=listOfArtist[index].subtitle;
                        }
                        audioC.player.listLength=listOfArtist.length;
                        playingList='artist';
                      },
                    ),
                  ); 
                },
              ),
            ),
          ],
        );
      },
    ); 
  }

  Widget favoriteButton(int index) {
    return listOfArtist[index].fav==1 ?ImageIcon(
      AssetImage('filledHeart.png'),
      color: Colors.purple[400]
    ): ImageIcon(
      AssetImage('heart.png'),
    );
  }

  Widget playButton(String title) {
    return Icon(audioC.player.musicaAtual==title && audioC.player.play? Icons.pause: Icons.play_arrow,size: 28.0,color: Colors.purple[400],);
  }
}