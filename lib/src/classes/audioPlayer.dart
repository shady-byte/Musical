import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'songsData.dart';

class Player {
  AudioPlayer _advancedPlayer;
  AudioCache _audioCache;
  Duration _duration=Duration(seconds: 0);
  Duration _position=Duration(seconds: 0);
  bool _play,_stop= false;
  int _index;
  String _tempMusica, _musicaAtual='';
  double _sliderVal;
  String _loacalFilePath;
  int _listLength;
  List<Songs> _playList;

  Player(this._advancedPlayer,this._audioCache,this._duration,this._position,this._play,this._loacalFilePath,
  this._sliderVal,this._musicaAtual,this._tempMusica,this._index,this._stop,this._listLength,this._playList);

  bool get play => _play;
  set play(bool value) => _play= value;
 

  String get musicaAtual => _musicaAtual;
  set musicaAtual(String value) => _musicaAtual= value;


  double get sliderVal => _sliderVal;
  set sliderVal(double value) => _sliderVal= value;


  int get index => _index;
  set index(int value) => _index= value;


  int get listLength => _listLength;
  set listLength(int value) => _listLength= value;


  String get loacalFilePath => _loacalFilePath;
  set loacalFilePath(String value) => _loacalFilePath = value;


  AudioCache get audioCache => _audioCache;
  set audioCache(AudioCache value) => _audioCache = value;


  AudioPlayer get advancedPlayer => _advancedPlayer;
  set advancedPlayer(AudioPlayer value) => _advancedPlayer = value;


  Duration get duration => _duration;
  set duration(Duration value) => _duration= value;


  Duration get position => _position;
  set position(Duration value) => _position= value;


  String get tempMusica => _tempMusica;
  set tempMusica(String value) => _tempMusica= value;


  bool get stop => _stop;
  set stop(bool value) => _stop= value;

  List<Songs> get playList => _playList;
  set playList(List<Songs> value) => _playList= value;
  
}