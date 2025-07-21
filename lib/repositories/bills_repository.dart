import 'dart:convert';

import 'package:saporra/core/consts/app_local_storage_keys.dart';
import 'package:saporra/core/errors/app_exception.dart';
import 'package:saporra/models/bill.dart';
import 'package:saporra/services/local_storage_service.dart';

class BillsRepository {
  static const String _key = AppLocalStorageKeys.bills;
  final LocalStorageService _localStorage;

  const BillsRepository(this._localStorage);

  Future<void> _saveList(List<Bill> bills) async {
    final list = bills.map((el) => el.toMap()).toList();
    await _localStorage.write(_key, jsonEncode(list));
  }

  Future<List<Bill>> getAll() async {
    final value = await _localStorage.read(_key);
    if (value == null || value.isEmpty) {
      return [];
    }

    try {
      return List.from(jsonDecode(value)).map((e) => Bill.fromMap(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> add(Bill newBill) async {
    final bills = await getAll();
    if (bills.contains(newBill)) {
      throw const AppException('Conta já existe');
    }
    bills.add(newBill);
    await _saveList(bills);
  }

  Future<void> remove(Bill bill) async {
    final bills = await getAll();
    if (!bills.contains(bill)) {
      throw const AppException('Comanda não existente');
    }
    bills.remove(bill);
    await _saveList(bills);
  }

  Future<void> edit(Bill bill) async {
    final bills = await getAll();
    final index = bills.indexWhere((el) => el.id == bill.id);
    if (index < 0) {
      throw const AppException('Comanda não existente');
    }
    bills[index] = bill;
    await _saveList(bills);
  }
}
