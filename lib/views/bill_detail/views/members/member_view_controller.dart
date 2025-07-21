import 'package:flutter/foundation.dart';
import 'package:saporra/core/errors/app_exception.dart';
import 'package:saporra/models/bill.dart';
import 'package:saporra/models/member.dart';
import 'package:saporra/models/shop_item.dart';
import 'package:saporra/repositories/bills_repository.dart';
import 'package:saporra/repositories/members_repository.dart';
import 'package:saporra/services/local_storage_service.dart';

class MemberViewController {
  final _billRepository = BillsRepository(LocalStorageService());
  final _membersRepository = MembersRepository(LocalStorageService());
  final members = ValueNotifier<List<Person>>([]);

  initialize(Bill bill, List<ShopItem> items) async {
    final allMembers = await _membersRepository.getAll();
    List<Person> billMembers = [];
    for (final item in items) {
      for (final memberId in item.payersIds) {
        final index = allMembers.indexWhere((el) => el.id == memberId);
        if (index >= 0) {
          final currentMember = allMembers[index];
          if (!billMembers.contains(currentMember)) {
            billMembers.add(currentMember);
          }
        }
      }
    }
    members.value = billMembers;
  }

  Future<void> onDeleteMember(Bill bill, Person member) async {
    if (!bill.membersIds.contains(member.id)) {
      throw const AppException('Member não pertence a comanda');
    }
    bill.membersIds.remove(member.id);

    if (!bill.membersIds.contains(member.id)) {
      throw const AppException('Member não pertence a comanda');
    }
    bill.membersIds.remove(member.id);

    await _billRepository.edit(bill);
  }

  Future<void> onAddMembers(Bill bill, List<Person> members) async {
    for (var member in members) {
      if (bill.membersIds.contains(member.id)) {
        throw AppException('Membro "${member.name}" já cadastrado');
      }
      bill.membersIds.add(member.id);
    }

    await _billRepository.edit(bill);
  }
}
