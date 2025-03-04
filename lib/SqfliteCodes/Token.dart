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
    Database myToken = await openDatabase(path, version: 1, onCreate: _createDB);
    return myToken;
  }

  _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE TOKENS(
      UUID TEXT ,
      TOKEN TEXT ,
      CREATED TEXT
      )
        ''');
  }

  // Add Token
  Future<int> addToken(String query) async {
    Database? myToken = await db; // Initialize the database
    int response = await myToken!.rawInsert(query);
    return response;
  }

  // Get Token
  Future<List<Map>> getToken(String query) async {
    Database? myToken = await db; // Initialize the database
    List<Map> response = await myToken!.rawQuery(query);
    return response;
  }

  // Update Token
  Future<int> updateToken(String query) async {
    Database? myToken = await db; // Initialize the database
    int response = await myToken!.rawUpdate(query);
    return response;
  }

  // Delete Token
  Future<int> deleteToken(String query) async {
    Database? myToken = await db; // Initialize the database
    int response = await myToken!.rawDelete(query);
    return response;
  }

  Future<void> recreateTokensTable() async {
    Database? myToken = await db; // Initialize the database

    // Drop the table if it exists
    await myToken!.execute('DROP TABLE IF EXISTS TOKENS');
    print("TOKENS table dropped successfully");

    // Recreate the table
    await _createDB(myToken, 1); // Use the same version as before
    print("TOKENS table recreated successfully");
  }

  Future<void> dropTable() async {
    Database? myToken = await db; // Initialize the database

    // Drop the table if it exists
    await myToken!.execute('DROP TABLE IF EXISTS TOKENS');
    print("TOKENS table dropped successfully");

  }

  Future<bool> isTokensTableEmpty() async {
    Database? myToken = await db; // Initialize the database

    // Query to count the number of rows in the TOKENS table
    List<Map> result = await myToken!.rawQuery('SELECT COUNT(*) as count FROM TOKENS');

    // Get the count from the result
    int count = result[0]['count'] as int;

    // If count is 0, the table is empty
    return count == 0;
  }
}

