import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Token {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();
      return _db;
    } else {
      return _db;
    }
  }

  initialDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'token.db');
    Database myToken = await openDatabase(path, onCreate: _createDB);
    return myToken;
  }

  _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "cart"(
      ID INTEGER AUTOINCREMENT NOT NULL PRIMARY KEY,
      IMAGEURL TEXT NOT NULL,
      NAME TEXT NOT NULL,
      CATEGORY TEXT NOT NULL,
      PRICE REAL NOT NULL,
      RATE REAL NOT NULL,
      SIZE,
      VOLUME,
      COLOR,
      MATERIAL,
      OTHER,
      COUNT REAL NOT NULL,   
      )
        ''');
  }

  addToken(String query) async{
    Database? myToken;
    int response = await myToken!.rawInsert(query);
    return response;
  }
  getToken(String query) async{
    Database? myToken = await db;
    List<Map> response = await myToken!.rawQuery(query);
    return response;
  }
  updateToken(String query) async{
    Database? myToken;
    int response = await myToken!.rawUpdate(query);
    return response;
  }
  deleteToken(String query) async{
    Database? myToken;
    int response = await myToken!.rawDelete(query);
    return response;
  }
}

