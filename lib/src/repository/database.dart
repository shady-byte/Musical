import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io' as io;
import '../classes/songsData.dart';

class DBHelper {
  static Database _db;
  static const String title='title';
  static const String subtitle='subtitle';
  static const String url='url';
  static const String fav='fav';
  static const String TABLE='favorites';
  static const String DB_NAME='favorite.db';

  Future<Database> get db async{
    if(_db !=null) {
      return _db;
    }
    _db= await initDb();
    return _db; 
  }

  initDb() async{
    io.Directory documentsDirectory= await getApplicationDocumentsDirectory();
    String path= join(documentsDirectory.path,DB_NAME);
    var db= await openDatabase(path, version:1, onCreate: _onCreate); 
    return db;
  }

  _onCreate(Database db, int version) async{
    await db.execute("CREATE TABLE $TABLE ($title TEXT PRIMARY KEY, $subtitle TEXT, $url TEXT, $fav INTEGER)");
  }

  Future<Songs> save(Songs song) async{
    var dbClient= await db;
    await dbClient.transaction((txn) async{
      var query= "INSERT INTO $TABLE ($title,$subtitle,$url,$fav)VALUES('"+song.title+"','"+song.subtitle+"','"+song.url+"',1)";
      return txn.rawInsert(query);
    });
  }

  Future<List<Songs>> getSongs() async{
    var dbClient=await db;
    List<Map> maps= await dbClient.query(TABLE,columns:[title,subtitle,url,fav]); 
    List<Songs> favLists=[];
    if(maps.length >0) {
      for(int i=0;i<maps.length;i++) {
        favLists.add(Songs.fromMap(maps[i]));
      }
      favList=favLists;
      for(var e in favList) {
        for(var a in playList) {
          if(e.title==a.title) {
              a.fav=1; 
          }
        }
      }
    }
    else{
      favList=[];
    }
    return favLists;
  }

  Future<int> delete(String key) async{
    var dbClient= await db;
    return await dbClient.delete(TABLE,where: '$title=?',whereArgs: [key]);
  }
/*
  dropTable() async{
    var dbClient= await db;
    return await dbClient.execute("DROP TABLE IF EXISTS $TABLE");
  }
*/
/*
  deleteDatabase() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DB_NAME);
    await deleteDatabase();
  }
  */
  Future close() async{
    var dbClient=await db;
    dbClient.close();
  }
}

DBHelper dbHelper=DBHelper();
