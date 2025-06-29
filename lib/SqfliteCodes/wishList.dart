import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class wishList {
  static final wishList _instance = wishList._internal();
  factory wishList() => _instance;
  wishList._internal();

  static Database? _db;

  Future<Database> get db async {
    return _db ??= await _initDB();
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'wishlist.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE WISHLIST(
        id TEXT,
        email TEXT
      )
    ''');
  }

  Future<int> addProduct({required String id, required String email}) async {
    final myWishlist = await db;
    print(email);
    print(await getProductIdsByEmail(email));
    return await myWishlist.insert('WISHLIST', {
      'id': id,
      'email': email,
    });
  }

  Future<List<String>> getProductIdsByEmail(String email) async {
    final myWishlist = await db;
    final result = await myWishlist.query('WISHLIST', where: 'email = ?', whereArgs: [email]);
    return result.map((row) => row['ID']?.toString() ?? "").toList();
  }

  Future<void> deleteProduct(String id, String email) async {
    final myWishlist = await db;
    print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;");

    print(id);
    print(email);
     await myWishlist.delete(
      'WISHLIST',
      where: 'id = ? AND email = ?',
      whereArgs: [id, email],
    );

     print(await getProductIdsByEmail(email));
  }

  Future<bool> isWishlistEmpty(String email) async {
    final myWishlist = await db;
    final result = await myWishlist.query('WISHLIST', where: 'email = ?', whereArgs: [email]);
    return result.isEmpty;
  }

  Future<bool> doesIdExist(String id, String email) async {
    final myWishlist = await db;
    final result = await myWishlist.query(
      'WISHLIST',
      where: 'id = ? AND email = ?',
      whereArgs: [id, email],
    );
    return result.isNotEmpty;
  }
}
