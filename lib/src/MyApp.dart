import 'package:flutter/material.dart';
import 'package:the_music_app/src/SingerScreen.dart';
import 'HomePage.dart';

class MyApp extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      //home: HomePage(),
      onGenerateRoute: routes,
      initialRoute: '/',
    );
    
  }

  Route routes(RouteSettings settings) {
    if(settings.name== '/') {
      return MaterialPageRoute(
        builder: (context){
          return HomePage();
        }
      );
    }
    
    else if(settings.name.contains('-')){
      return MaterialPageRoute(
        builder: (context) {
          return SingerScreen();
        }
      );
    }
  }
}