import 'package:flutter/foundation.dart';
import 'package:splitus/models/bill.dart';
import 'package:splitus/models/member.dart';
import 'package:splitus/repositories/bills_repository.dart';
import 'package:splitus/repositories/items_repository.dart';
import 'package:splitus/repositories/members_repository.dart';
import 'package:splitus/services/local_storage_service.dart';

class AddMembersPageController {
  final _billsRepository = BillsRepository(LocalStorageService());
  final _itemsRepository = ItemsRepository(LocalStorageService());
  final _membersRepository = MembersRepository(LocalStorageService());

  final members = ValueNotifier<List<Person>>([]);
  final isLoadingRemoval = ValueNotifier<bool>(false);

  Future<void> refresh() async {
    members.value = await _membersRepository.getAll();
  }

  Future<Bill?> _hasPendentBill(Person member) async {
    final allItems = await _itemsRepository.getAll();

    for (final item in allItems) {
      if (item.payersIds.contains(member.id)) {
        final bills = await _billsRepository.getAll();
        final bill = bills.firstWhere((el) => el.id == item.billId);
        return bill;
      }
    }
    return null;
  }

  Future<Bill?> removeMember(Person member) async {
    if (isLoadingRemoval.value) {
      return null;
    }

    try {
      isLoadingRemoval.value = true;
      final pendentBill = await _hasPendentBill(member);
      if (pendentBill != null) {
        isLoadingRemoval.value = false;
        return pendentBill;
      }
      await _membersRepository.remove(member);
      await refresh();
      isLoadingRemoval.value = false;
      return null;
    } catch (e) {
      isLoadingRemoval.value = false;
      return null;
    }
  }
}
