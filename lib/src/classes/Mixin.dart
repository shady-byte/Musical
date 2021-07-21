import 'songsData.dart';
import '../repository/database.dart';

mixin Functions {

  findArtists() {
    for(var e in playList) {
      if(singers.isEmpty) {
        singers.add(e.subtitle);
      }
      else {
        if(!singers.contains(e.subtitle)) {
          singers.add(e.subtitle);
        }
      }
    }
  }

  songsOfArtist() {
    List<Songs> list=[];
    for(var e in playList) {
      if(e.subtitle.contains(artistName)) {
        list.add(e);
      }
    }
    listOfArtist=list;
  }

  checkFavButton(int index) {
    for(var a in playList) {
      if(a.title==listOfArtist[index].title) {
        if(a.fav==1) {
          removeData(listOfArtist[index].title);
          a.fav=0;
          listOfArtist[index].fav=0;
        }
        else {
          Songs song=Songs(listOfArtist[index].title,listOfArtist[index].subtitle,listOfArtist[index].url,1);
          addData(song);
          a.fav=1;
          listOfArtist[index].fav=1;
        }
      }
    }
  }

  swipeItem(String title) {
    for(var a in playList) {
      if(a.title==title) {
        a.fav=0;
        removeData(title);
        for(var e in listOfArtist) {
          if(e.title==title) {
            e.fav=0;
          }
        }
      } 
    }
  }

  addData(Songs song) {
    dbHelper.save(song);
  }

  removeData(String title) {
    dbHelper.delete(title);
  }
}