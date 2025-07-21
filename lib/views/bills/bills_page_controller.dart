import 'package:flutter/material.dart';
import 'package:saporra/models/bill.dart';
import 'package:saporra/repositories/bills_repository.dart';
import 'package:saporra/services/local_storage_service.dart';

class BillsPageController {
  final _billRepository = BillsRepository(LocalStorageService());
  final ValueNotifier<List<Bill>> bills = ValueNotifier([]);

  Future<void> initialize() async {
    final list = await _billRepository.getAll();
    bills.value = list;
  }

  Future<void> deleteBill(Bill bill) async {
    _billRepository.remove(bill);
  }
}
