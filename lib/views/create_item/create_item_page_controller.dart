import 'package:flutter/foundation.dart';
import 'package:splitus/models/member.dart';
import 'package:splitus/repositories/members_repository.dart';
import 'package:splitus/services/local_storage_service.dart';

class CreateItemPageController {
  final _membersRepository = MembersRepository(LocalStorageService());
  final currentMembers = ValueNotifier<List<Person>>([]);
  final members = ValueNotifier<List<Person>>([]);

  int _sortPerson(Person p1, Person p2) {
    if (currentMembers.value.contains(p1)) {
      return -1;
    }
    if (currentMembers.value.contains(p2)) {
      return 1;
    }
    return 0;
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
}
