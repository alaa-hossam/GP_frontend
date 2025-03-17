import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Cart {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();
    }
    return _db;
  }

  Future<Database> initialDB() async {
    print("initialize cart");
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'cart.db');
    Database myCart = await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
    return myCart;
  }

  Future<void> _createDB(Database db, int version) async {
    print('Creating database tables...'); // Debug log

    // Create the products table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS products(
        id TEXT,
        finalId TEXT
      )
    ''');
    //
    // // Create the variations table
    // await db.execute('''
    //   CREATE TABLE IF NOT EXISTS variations(
    //     id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     product_id TEXT,
    //     variationType TEXT,
    //     variationValue TEXT
    //   )
    // ''');
    //
    // // Create the finalProducts table
    // await db.execute('''
    //   CREATE TABLE IF NOT EXISTS finalProducts(
    //     id TEXT PRIMARY KEY,
    //     product_id TEXT,
    //     customPrice REAL,
    //     ImageUrl TEXT
    //   )
    // ''');

    print('Database tables created successfully'); // Debug log
  }

  Future<int> addProduct(String id, String finalId) async {
    Database? myCart = await db;

    int response = await myCart!.rawInsert('''
      INSERT INTO products(id, finalId) 
      VALUES (?, ?)
    ''', [id , finalId]);

    return response;
  }

  Future<List<Map>> getProduct(String query, [List<dynamic>? arguments]) async {
    Database? myCart = await db;
    List<Map> response = await myCart!.rawQuery(query, arguments);
    return response;
  }

  Future<void> recreateProductsTable() async {
    Database? product = await db; // Initialize the database

    // Drop the table if it exists
    await product!.execute('DROP TABLE IF EXISTS products');
    print("products table dropped successfully");

    // Recreate the table
    await _createDB(product, 1);
    print("products table recreated successfully");
  }
}