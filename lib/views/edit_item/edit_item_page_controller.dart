import 'package:flutter/foundation.dart';
import 'package:splitus/models/member.dart';
import 'package:splitus/models/shop_item.dart';
import 'package:splitus/repositories/items_repository.dart';
import 'package:splitus/repositories/members_repository.dart';
import 'package:splitus/services/local_storage_service.dart';

class EditItemPageController {
  final _membersRepository = MembersRepository(LocalStorageService());
  final _itemsRepository = ItemsRepository(LocalStorageService());
  final currentMembers = ValueNotifier<List<Person>>([]);
  final members = ValueNotifier<List<Person>>([]);
  final isLoading = ValueNotifier<bool>(false);

  int _sortPerson(Person p1, Person p2) {
    if (currentMembers.value.contains(p1)) {
      return -1;
    }
    if (currentMembers.value.contains(p2)) {
      return 1;
    }
    return 0;
  }

  Future<void> loadInitialData(ShopItem item) async {
    await getMembers();
    currentMembers.value = members.value.where((el) => item.payersIds.contains(el.id)).toList();
    members.value.sort(_sortPerson);
    members.value = members.value;
  }

  Future<void> getMembers() async {
    members.value = await _membersRepository.getAll();
  }

  Future<void> onAddMember(Person member) async {
    final allMembers = await _membersRepository.getAll();
    if (!currentMembers.value.contains(member)) {
      currentMembers.value.add(member);
      currentMembers.value = currentMembers.value;
    }
    allMembers.sort(_sortPerson);
    members.value = allMembers;
  }

  Future<void> onEditItem(ShopItem item) async {
    try {
      isLoading.value = true;
      await _itemsRepository.edit(item);
    } finally {
      isLoading.value = false;
    }
  }
}
