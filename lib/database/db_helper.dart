// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:fake_store/Models/getFavourites.dart';
import 'package:fake_store/Models/getusers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:fake_store/Models/getCarts.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path;
    final database =
        await openDatabase('${path}cart.db', version: 1, onCreate: _onCreate);

    return database;
  }

  _onCreate(
    Database db,
    int version,
  ) async {
    await db.execute(
      """
      CREATE TABLE IF NOT EXISTS cart (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      product_id VARCHAR,
      product_name TEXT,
      product_unit TEXT,
      product_price DOUBLE,
      product_total_price DOUBLE,
      product_quantity INTEGER,
      product_image TEXT
      )
      """,
    );

    await db.execute(
      """
      CREATE TABLE IF NOT EXISTS favorites (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      product_id VARCHAR,
      product_name TEXT,
      product_unit TEXT,
      product_price DOUBLE,
      product_image TEXT
      )
      """,
    );

    await db.execute(
      """
      CREATE TABLE IF NOT EXISTS users (
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_name TEXT,
      user_email TEXT,     
      user_password TEXT,
      user_image TEXT
      )
      """,
    );
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await db;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<Favourite> insertFavorite(Favourite fav) async {
    var dbClient = await db;
    await dbClient!.insert('favorites', fav.toMap());
    return fav;
  }

  Future<User> insertUser(User user) async {
    var dbClient = await db;
    int id = await dbClient!.insert('users', user.toMap());

    user.user_id = id;

    return user;
  }

  Future<List<Cart>> getCartList(int userId) async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query(
      'cart',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<List<Favourite>> getFavoriteList(int userId) async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query(
      'favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return queryResult.map((e) => Favourite.fromMap(e)).toList();
  }

  Future<User?> getUserByEmail(String email) async {
    var dbClient = await db;
    var result = await dbClient!.query(
      'users',
      where: 'user_email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<int> deletProduct(int id) async {
    var dbClient = await db;
    return dbClient!.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletFavProduct(String productName) async {
    var dbClient = await db;
    return dbClient!.delete(
      'favorites',
      where: 'product_name = ?',
      whereArgs: [productName],
    );
  }

  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await db;
    return dbClient!.update(
      'cart',
      cart.toMap(),
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [cart.user_id, cart.product_id],
    );
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return dbClient!.update(
      'users',
      user.toMap(),
      where: 'user_id = ?',
      whereArgs: [user.user_id],
    );
  }

  Future<bool> checkIfProductExists(int userId, String productName) async {
    var dbClient = await db;
    var result = await dbClient!.query(
      'cart',
      where: 'user_id = ? AND product_name = ?',
      whereArgs: [userId.toString(), productName],
    );
    return result.isNotEmpty;
  }

  Future<bool> checkIfFavouriteProductExists(String productId) async {
    var dbClient = await db;
    var result = await dbClient!.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty;
  }

  Future<bool> checkIfUserExists(String userEmail) async {
    var dbClient = await db;
    var result = await dbClient!.query(
      'users',
      where: 'user_email = ?',
      whereArgs: [userEmail],
    );
    return result.isNotEmpty;
  }
}
