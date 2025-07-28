import 'package:flutter/material.dart';
import 'package:splitus/models/bill.dart';
import 'package:splitus/repositories/bills_repository.dart';
import 'package:splitus/repositories/items_repository.dart';
import 'package:splitus/services/local_storage_service.dart';

class BillsPageController {
  final _billRepository = BillsRepository(LocalStorageService());
  final _itemsRepository = ItemsRepository(LocalStorageService());
  final ValueNotifier<List<Bill>> bills = ValueNotifier([]);

  Future<void> initialize() async {
    final list = await _billRepository.getAll();
    bills.value = list;
  }

  Future<void> createBill(Bill bill) async {
    await _billRepository.add(bill);
    await initialize();
  }

  Future<void> deleteBill(Bill bill) async {
    await _billRepository.remove(bill);
    final items = await _itemsRepository.getAllByBill(bill);
    await _itemsRepository.removeBatch(items);
    await initialize();
  }
}
