import 'package:flutter/material.dart';
import 'classes/audioPlayerController.dart';
import 'classes/audioPlayer.dart';
import 'classes/songsData.dart';
import 'repository/database.dart';

class PlayerScreen extends StatefulWidget {
  createState() {
    return PlayerState();
  }
}

class PlayerState extends State<PlayerScreen> {
  Future<List<Songs>> savedSongs;
  initState() {
    super.initState();
    refreshList();
  }

  refreshList() {
    setState(() {
      savedSongs=dbHelper.getSongs();
    });
    if(playingList=='favorites') {
      audioC.player.listLength=favList.length;
      audioC.player.playList=favList;
    }
    else if(playingList=='artist'){
      audioC.player.listLength=listOfArtist.length;
      audioC.player.playList=listOfArtist;
    }
    
  }

  Widget build(context) {
    var screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder(
        stream: audioC.outPlayer,
        builder: (context, AsyncSnapshot<Player> snapshot) {
          return Column(
            children: [
              //Container of song name and artist photo and slider
              Container(
                width: screenSize.width,
                height: 0.6*screenSize.height,
                padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                //color: Colors.red,
                child: Column(
                  children: [
                    Text(
                      audioC.player.playList.isNotEmpty ? audioC.player.playList[audioC.player.index].title : 'Listen Now!',
                      style: TextStyle(fontSize: 28.0,fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 0.8*screenSize.width,
                      height: 0.29*screenSize.height,
                      margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 30.0),
                      decoration: BoxDecoration(
                        //color:Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        image: DecorationImage(
                          image: audioC.player.playList.isNotEmpty ? 
                          AssetImage(
                            singerName.replaceAll(new RegExp(r"\s+"), "")+'.jpg'):
                          AssetImage('music.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    slider(screenSize,snapshot.data),
                  ],
                ),
              ),
              //Container of the player controls
              Container(
                width: screenSize.width,
                height: 0.322*screenSize.height,
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                //color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 60,
                      icon: Icon(Icons.skip_previous,),
                        onPressed: () {
                          if(audioC.player.index==0){
                            String x=audioC.player.playList[audioC.player.listLength-1].url+'.mp3';
                            audioC.addMusic(x,audioC.player.listLength-1);  
                          }
                          else{
                            String x=audioC.player.playList[audioC.player.index-1].url+'.mp3';
                            audioC.addMusic(x,audioC.player.index-1);
                          }
                          singerName=audioC.player.playList[audioC.player.index].subtitle;
                        },
                      ),
                      IconButton(
                        iconSize: 120,
                        icon: Icon(snapshot.data.play ? Icons.pause_circle_outline : Icons.play_circle_outline ,color: Colors.purple[400],),  
                          onPressed: () {
                            audioC.buttonPlayPause();
                          },
                      ),
                    IconButton(
                      iconSize: 60,
                      icon: Icon(Icons.skip_next),
                        onPressed: () {
                          if(audioC.player.index==audioC.player.listLength-1){
                            String x=audioC.player.playList[0].url+'.mp3';
                            audioC.addMusic(x,0);  
                          }
                          else{
                            String x=audioC.player.playList[audioC.player.index+1].url+'.mp3';
                            audioC.addMusic(x,audioC.player.index+1);
                          }
                          singerName=audioC.player.playList[audioC.player.index].subtitle;
                        },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ), 
    );
  }

  Widget slider(Size screen,Player play) {
    return Container(
      //color: Colors.red,
      width: 0.85*screen.width,
      height: 0.08*screen.height,
      child: Column(
        children: [
          //slider 
          Slider(
            activeColor: Colors.purple[400],
            inactiveColor: Colors.grey[300],
            value: play.position.inSeconds.toDouble(),
            min: 0.0,
            max: play.duration.inSeconds.toDouble()+1,
            onChanged: (newVal) {
              audioC.tempMusic(newVal);
            },
          ),
          //the time of the player
          Container(
            //color: Colors.blue,
            width: 0.77*screen.width,
            height: 0.024*screen.height,
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                calculate(play.position.inSeconds.toInt()),
                calculate(play.duration.inSeconds.toInt()),
              ],
            ),
          ),
         
        ],
      ),
    ); 
  }
}
Widget calculate(int value) {
  int minutes= (value/60).toInt();
  String minute= (value/60).toInt().toString();
  String seconds=(value-minutes*60).toString();
  if(seconds.length<=1) {
    seconds="0"+seconds;
  }

  if(minute.length <=1) {
    minute="0"+minute;
  }
  return Text(
    '$minute:$seconds',
    style: TextStyle(
      color:Colors.grey,
      fontSize: 13.0,
    ),
  );
}