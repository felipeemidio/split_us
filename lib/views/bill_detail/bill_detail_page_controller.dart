import 'package:flutter/foundation.dart';
import 'package:splitus/models/bill.dart';
import 'package:splitus/models/shop_item.dart';
import 'package:splitus/repositories/items_repository.dart';
import 'package:splitus/services/local_storage_service.dart';

class BillDetailPageController {
  final _itemsRepository = ItemsRepository(LocalStorageService());
  final items = ValueNotifier<List<ShopItem>>([]);

  double get total => items.value.fold<double>(0, (sum, e) => sum + e.price);

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
