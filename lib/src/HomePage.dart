import 'package:flutter/material.dart';
import 'classes/Mixin.dart';
import 'favoritesPage.dart';
import 'FavoriteScreen.dart';
import 'PlayerScreen.dart';
import 'classes/songsData.dart';
import 'repository/database.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> with Functions{
  int _selectedIcon=0;
  PageController _pageController=PageController();
  List<Widget> _screens=[FavoriteScreen(),FavoritePage(),PlayerScreen()];


  Future<List<Songs>> _getSongs() async{
    dbHelper.getSongs();
    var data= await DefaultAssetBundle.of(context).loadString("assets/songs.json");
    var jsonData= json.decode(data);
    for(var u in jsonData) {
        Songs song=new Songs(u['title'],u['subtitle'],u['url'],0);
        addSong2(song);
    }
    findArtists();
    return playList;
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIcon=index;
    });
  }
  void _itemtapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  Widget build(context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getSongs(),
        builder: (context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData) {
            return Center(
            child: CircularProgressIndicator(),
            );
          }
          return PageView(
              controller: _pageController,
              children: _screens,
              onPageChanged: _onPageChanged,
              physics: NeverScrollableScrollPhysics(),
          );
        },
      ), 
      
      
      bottomNavigationBar: BottomNavigationBar(
        onTap: _itemtapped,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon:Icon(Icons.search,color: _selectedIcon==0 ? Colors.purple[400]: Colors.grey,size: 35.0,),
            title: Text(
              'Explore',
              style: TextStyle(color: _selectedIcon==0 ? Colors.purple[400]: Colors.grey),
          )),

          BottomNavigationBarItem(
            icon:ImageIcon(AssetImage('heart.png'),color: _selectedIcon==1 ? Colors.purple[400]: Colors.grey,size: 35.0,),
            title: Text(
              'Favorites',
              style: TextStyle(color: _selectedIcon==1 ? Colors.purple[400]: Colors.grey),
          )),

          BottomNavigationBarItem(
            icon:Icon(Icons.play_arrow,color: _selectedIcon==2 ? Colors.purple[400]: Colors.grey,size: 35.0,),
            title: Text(
              'Player',
              style: TextStyle(color: _selectedIcon==2 ? Colors.purple[400]: Colors.grey),
          )),

        ]),
    ); 
  }
}
