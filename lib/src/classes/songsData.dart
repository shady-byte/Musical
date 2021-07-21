class Songs{
   String title;
   String subtitle;
   String url;
   int fav;

  Songs(this.title,this.subtitle,this.url,this.fav);

  Map<String,String> toMap() {
    var map= <String,dynamic>{
      'title':title,
      'subtitle':subtitle,
      'url':url,
      'fav':fav
    };

    return map;
  }

  Songs.fromMap(Map<String,dynamic> map) {
    title=map['title'];
    subtitle=map['subtitle'];
    url=map['url'];
    fav=map['fav'];
  }

}
List<Songs> favList=[];
List<Songs> playList=[];
List<String> singers=[];
List<Songs> listOfArtist=[];
String artistName,playingList,singerName;


List<Songs> sendSong() {
  return favList;
}

addSong2(Songs song) {
  int i=0;
  for(var e in playList) {
    if(e.title==song.title) {
      i=1;
    }
  }
  if(i==0) {
    playList.add(song);
  }
}

List<Songs> sendSong2() {
  return playList;
}

removeSong(String title) {
  favList.removeWhere((element) => element.title==title);
}