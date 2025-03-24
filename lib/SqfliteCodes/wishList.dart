import 'package:gp_frontend/ViewModels/customerViewModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class wishList {
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
    String path = join(databasePath, 'wishlist.db');
    Database myWishlist = await openDatabase(path, version: 1, onCreate: _createDB);
    return myWishlist;
  }

  _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "WISHLIST"(
        ID TEXT,
        EMAIL TEXT
       
      )
    ''');
  }

  Future<List<String>> getProductIdsByEmail(String email) async {
    // Get the database instance

    Database? myWishlist = await db; // Initialize the database

    // Query the WISHLIST table for rows where email matches
    List<Map<String, dynamic>> result = await myWishlist!.query(
      'WISHLIST',
      where: 'EMAIL = ?',
      whereArgs: [email],
    );

    // Extract the IDs from the result
    List<String> productIds = result.map<String>((row) => row['ID'].toString()).toList();

    // Close the database connection

    return productIds;
  }

  //
  // IMAGEURL TEXT NOT NULL,
  //     NAME TEXT NOT NULL,
  // CATEGORY TEXT NOT NULL,
  // RATE REAL NOT NULL
  //     PRICE REAL NOT NULL,

  // Corrected method: Initialize myWishlist using the db getter
  addProduct(String query) async {
    Database? myWishlist = await db; // Initialize the database
    int response = await myWishlist!.rawInsert(query);
    return response;
  }

  // Corrected method: Initialize myWishlist using the db getter
  Future<List<Map>> getProduct(String query) async {
    Database? myWishlist = await db; // Initialize the database
    List<Map> response = await myWishlist!.rawQuery(query);
    return response;
  }

  // Corrected method: Initialize myWishlist using the db getter
  updateProduct(String query) async {
    Database? myWishlist = await db; // Initialize the database
    int response = await myWishlist!.rawUpdate(query);
    return response;
  }

  // Corrected method: Initialize myWishlist using the db getter
  deleteProduct(String query) async {
    Database? myWishlist = await db; // Initialize the database
    // print(myWishlist!.rawQuery("SELECT COUNT(*) as count FROM WISHLIST where EMAIL =  'maryamsakr625@gmail.com'"));
    int response = await myWishlist!.rawDelete(query);
    print("delete in wish");
    print(await myWishlist.rawQuery('SELECT COUNT(*) as count FROM WISHLIST'));
    return response;
  }

  Future<bool> isWishlistTableEmpty() async {
    Database? myWishList = await db; // Initialize the database

    // Query to count the number of rows in the WISHLIST table
    List<Map> result = await myWishList!.rawQuery('SELECT COUNT(*) as count FROM WISHLIST');

    // Get the count from the result
    int count = result[0]['count'] as int;

    // If count is 0, the table is empty
    return count == 0;
  }

  Future<void> recreateWishListTable() async {
    Database? myWish = await db; // Initialize the database

    // Drop the table if it exists
    await myWish!.execute('DROP TABLE IF EXISTS WISHLIST');
    print("Wishlist table dropped successfully");

    // Recreate the table
    await _createDB(myWish, 1);
    print("Wishlist table recreated successfully");
  }

  Future<bool> doesIdExist(String id) async {
    Database? myWishlist = await db;
    customerViewModel customer =customerViewModel();
    String email = await customer.getEmail();

    List<Map> result = await myWishlist!.rawQuery(
      'SELECT 1 FROM WISHLIST WHERE ID = ? AND EMAIL = "$email"',
      [id],
    );

    return result.isNotEmpty;
  }
}