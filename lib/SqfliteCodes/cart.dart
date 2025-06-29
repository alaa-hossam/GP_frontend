import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Cart {
  static final Cart _instance = Cart._internal();
  factory Cart() => _instance;
  Cart._internal();

  static Database? _db;

  Future<Database> get db async {
    return _db ??= await _initDB();
  }

  Future<Database> _initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'cart.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS products(
        id TEXT,
        finalId TEXT,
        userId TEXT
      )
    ''');
  }

  Future<int> addProduct({required String id, required String finalId, required String userId}) async {
    final myCart = await db;
    print(await getProductIdsByUser(userId));
    print("******************");
    return await myCart.insert('products', {
      'id': id,
      'finalId': finalId,
      'userId': userId,
    });
  }

  Future<List<String>> getProductIdsByUser(String userId) async {
    final myCart = await db;
    print("............................");
    final result = await myCart.query(
      'products',
      columns: ['finalId'], // only fetch the `id` column
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return result.map((row) => row['finalId'].toString()).toList();
  }
  Future<int> deleteProduct(String finalId, String userId) async {
    final myCart = await db;
    return await myCart.delete(
      'products',
      where: 'finalId = ? AND userId = ?',
      whereArgs: [finalId, userId],
    );
  }

  Future<int> deleteAllUserProducts(String userId) async {
    final myCart = await db;
    return await myCart.delete('products', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<bool> isCartEmpty(String userId) async {
    final myCart = await db;
    final result = await myCart.query('products', where: 'userId = ?', whereArgs: [userId]);
    return result.isEmpty;
  }

  Future<void> deleteDatabaseFile() async {
    String path = join(await getDatabasesPath(), 'cart.db');
    await deleteDatabase(path);
  }

}
