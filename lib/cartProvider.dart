// ignore_for_file: prefer_const_constructors

import 'package:fake_store/database/db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  DBHelper db = DBHelper();

  // Store favorite status and cart info per user
  Map<int, List<bool>> _isFavourite = {};
  Map<int, int> _counter = {};
  Map<int, int> _favouriteCount = {};
  Map<int, double> _totalPrice = {};

  List<bool> getIsFavourite(int userId) {
    return _isFavourite[userId] ?? List<bool>.filled(8, false);
  }

  int getCounter(int userId) {
    return _counter[userId] ?? 0;
  }

  int getFavouriteCounter(int userId) {
    return _favouriteCount[userId] ?? 0;
  }

  double getTotalPrice(int userId) {
    return _totalPrice[userId] ?? 0.0;
  }

  CartProvider() {
    _loadPreferences();
  }

  void toggleFavourite(int userId, int index) {
    _isFavourite[userId] = getIsFavourite(userId);
    _isFavourite[userId]![index] = !_isFavourite[userId]![index];
    notifyListeners();
    _saveFavorites(userId);
  }

  void setFavourite(int userId, int index, bool value) {
    _isFavourite[userId] = getIsFavourite(userId);
    _isFavourite[userId]![index] = value;
    notifyListeners();
    _saveFavorites(userId);
  }

  Future<void> _saveFavorites(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIndices = _isFavourite[userId]!
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => entry.key.toString())
        .toList();
    await prefs.setStringList('favoriteIndices_$userId', favoriteIndices);
  }

  Future<void> _loadFavoritesForUser(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites =
        prefs.getStringList('favoriteIndices_$userId');
    if (savedFavorites != null) {
      _isFavourite[userId] = List.generate(
        8, // Assuming there are 8 products, adjust if necessary
        (index) => savedFavorites.contains(index.toString()),
      );
    } else {
      _isFavourite[userId] = List<bool>.filled(8, false);
    }
  }

  Future<void> _loadPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Set<String> keys = sp.getKeys();

    for (String key in keys) {
      if (key.startsWith('cart_item_')) {
        int userId = int.parse(key.split('_').last);
        _counter[userId] = sp.getInt(key) ?? 0;
      } else if (key.startsWith('favourite_item_')) {
        int userId = int.parse(key.split('_').last);
        _favouriteCount[userId] = sp.getInt(key) ?? 0;
      } else if (key.startsWith('total_price_')) {
        int userId = int.parse(key.split('_').last);
        _totalPrice[userId] = sp.getDouble(key) ?? 0.0;
      } else if (key.startsWith('favoriteIndices_')) {
        int userId = int.parse(key.split('_').last);
        await _loadFavoritesForUser(userId);
      }
    }

    notifyListeners();
  }

  void addTotalPrice(int userId, double productPrice) {
    _totalPrice[userId] = getTotalPrice(userId) + productPrice;
    _savePreferences(userId);
    notifyListeners();
  }

  void removeTotalPrice(int userId, double productPrice) {
    _totalPrice[userId] = getTotalPrice(userId) - productPrice;
    _savePreferences(userId);
    notifyListeners();
  }

  void addCounter(int userId) {
    _counter[userId] = getCounter(userId) + 1;
    _savePreferences(userId);
    notifyListeners();
  }

  void removeCounter(int userId) {
    _counter[userId] = getCounter(userId) - 1;
    _savePreferences(userId);
    notifyListeners();
  }

  void addFavouriteCounter(int userId) {
    _favouriteCount[userId] = getFavouriteCounter(userId) + 1;
    _savePreferences(userId);
    notifyListeners();
  }

  void removeFavouriteCounter(int userId) {
    _favouriteCount[userId] = getFavouriteCounter(userId) - 1;
    _savePreferences(userId);
    notifyListeners();
  }

  void _savePreferences(int userId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('cart_item_$userId', getCounter(userId));
    sp.setInt('favourite_item_$userId', getFavouriteCounter(userId));
    sp.setDouble('total_price_$userId', getTotalPrice(userId));
  }
}
