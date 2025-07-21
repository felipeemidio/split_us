import 'package:flutter/foundation.dart';
import 'package:saporra/models/shop_item.dart';
import 'package:saporra/repositories/items_repository.dart';
import 'package:saporra/services/local_storage_service.dart';

class BillDetailPageController {
  final _itemsRepository = ItemsRepository(LocalStorageService());
  final items = ValueNotifier<List<ShopItem>>([]);

  Future<void> getItems() async {
    items.value = await _itemsRepository.getAll();
  }
}
