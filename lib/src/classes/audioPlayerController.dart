import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'audioPlayer.dart';
import 'songsData.dart';


class AudioPlayerController extends BlocBase{
  
  BehaviorSubject<Player> durB=new BehaviorSubject <Player>();

  Stream<Player> get outPlayer => durB.stream;
  Sink<Player> get inPlayer => durB.sink;


  AudioPlayer advancedPlayer=new AudioPlayer();
  Player player;

  AudioPlayerController() {
    player=new Player(
      advancedPlayer,
      new AudioCache(fixedPlayer:advancedPlayer),
      new Duration(seconds: 0),
      new Duration(seconds: 0),
      false,
      "",0,
      "","",0,false,0,[]);

    //player 1 controls play list screen
    player.advancedPlayer.onDurationChanged.listen((Duration d) {
      player.duration=d;
      inPlayer.add(player);
    });

    player.advancedPlayer.onAudioPositionChanged.listen((Duration p) {
      player.position=p;
      inPlayer.add(player);
    });

    player.advancedPlayer.onPlayerCompletion.listen((event) {
      if(player.index==player.listLength-1){
        player.audioCache.play(player.playList[0].url+'.mp3');
        player.musicaAtual=player.playList[0].url+'.mp3';
        player.index=0;
      }
      else{
        String x=player.playList[player.index+1].url+'.mp3';
        player.audioCache.play(x);
        player.musicaAtual=x;
        player.index=player.index+1;
      }
      inPlayer.add(player);      
    });

    player.advancedPlayer.onPlayerStateChanged.listen((event) =>{
      if(event.toString()== 'AudioPlayerState.STOPPED'){
          player.position= Duration(seconds: 0),
          inPlayer.add(player),
      }
    });
    
    player.musicaAtual='song0.mp3';
    inPlayer.add(player);
  }

  buttonPlayPause() {
    if(player.play) {
    player.play= false;
    player.advancedPlayer.pause();
    }
    else {
      player.play= true;
      player.audioCache.play(player.musicaAtual);
    }
    inPlayer.add(player);
  }

  buttonStop() {
    if(player.stop==true) {
      player.play=false;
    }
    player.advancedPlayer.stop();
    inPlayer.add(player);
  }

  addMusic(String musica,int index) {
    player.musicaAtual=musica;
    player.advancedPlayer.stop();
    player.audioCache.play(player.musicaAtual);
    player.play= true;
    player.index=index;
    inPlayer.add(player);
  }

  tempMusic(double newVal) {
    Duration newDuration= Duration(seconds: newVal.toInt());

    player.advancedPlayer.seek(newDuration);
    player.tempMusica= newVal.toStringAsFixed(0);
    player.advancedPlayer.resume();
    player.play= true;
    inPlayer.add(player);
  }
}
AudioPlayerController audioC=new AudioPlayerController();