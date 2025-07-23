import 'package:flutter/foundation.dart';
import 'package:saporra/models/bill.dart';
import 'package:saporra/models/shop_item.dart';
import 'package:saporra/repositories/items_repository.dart';
import 'package:saporra/services/local_storage_service.dart';

class BillDetailPageController {
  final _itemsRepository = ItemsRepository(LocalStorageService());
  final items = ValueNotifier<List<ShopItem>>([]);

  Future<void> getItems(Bill bill) async {
    items.value = await _itemsRepository.getAllByBill(bill);
  }

  Future<void> addItem(ShopItem item, Bill bill) async {
    await _itemsRepository.add(item);
    await getItems(bill);
  }

  Future<void> removeItem(ShopItem item, Bill bill) async {
    await _itemsRepository.remove(item);
    await getItems(bill);
  }
}
