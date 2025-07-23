import 'dart:convert';

import 'package:saporra/core/consts/app_local_storage_keys.dart';
import 'package:saporra/core/errors/app_exception.dart';
import 'package:saporra/models/bill.dart';
import 'package:saporra/models/shop_item.dart';
import 'package:saporra/services/local_storage_service.dart';

class ItemsRepository {
  static const String _key = AppLocalStorageKeys.items;
  final LocalStorageService _localStorageService;

  const ItemsRepository(this._localStorageService);

  Future<void> _saveList(List<ShopItem> items) async {
    final list = items.map((el) => el.toMap()).toList();
    await _localStorageService.write(_key, jsonEncode(list));
  }

  Future<List<ShopItem>> getAll() async {
    final value = await _localStorageService.read(_key);
    if (value == null || value.isEmpty) {
      return [];
    }

    try {
      final rawList = jsonDecode(value) as List;
      return rawList.map((e) => ShopItem.fromMap(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<ShopItem>> getAllByBill(Bill bill) async {
    final items = await getAll();
    return items.where((item) => item.billId == bill.id).toList();
  }

  Future<void> add(ShopItem item) async {
    final items = await getAll();
    if (items.contains(item)) {
      throw const AppException('Conta já existe');
    }
    items.add(item);
    await _saveList(items);
  }

  Future<void> remove(ShopItem item) async {
    final items = await getAll();
    if (!items.contains(item)) {
      throw const AppException('Comanda não existente');
    }
    items.remove(item);
    await _saveList(items);
  }

  Future<void> edit(ShopItem item) async {
    final items = await getAll();
    final index = items.indexWhere((el) => el.id == item.id);
    if (index < 0) {
      throw const AppException('Item não existente');
    }
    items[index] = item;
    await _saveList(items);
  }
}
