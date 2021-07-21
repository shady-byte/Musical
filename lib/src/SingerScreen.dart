import 'package:flutter/material.dart';
import 'favoritesPage.dart';
import 'PlayerScreen.dart';
import 'artist.dart';

class SingerScreen extends StatefulWidget {
  createState() {
    return SingerState();
  }
}

class SingerState extends State<SingerScreen> {
  int _selectedIcon=0;
  PageController _pageController=PageController();
  List<Widget> _screens=[Artist(),FavoritePage(),PlayerScreen()];

  void _onPageChanged(int index) {
    setState(() {
        _selectedIcon=index;
    });
    print(_selectedIcon);
  }
  void _itemtapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  Widget build(context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
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
            icon:ImageIcon(AssetImage('assets/heart.png'),color: _selectedIcon==1 ? Colors.purple[400]: Colors.grey,size: 35.0,),
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
/*
  Widget favoriteButton() {
    return ImageIcon(
      AssetImage('assets/heart.png'),
    );
  }
*/
}