import 'package:flutter/foundation.dart';
import 'package:saporra/models/member.dart';
import 'package:saporra/repositories/members_repository.dart';
import 'package:saporra/services/local_storage_service.dart';

class AddMembersPageController {
  final _membersRepository = MembersRepository(LocalStorageService());

  final members = ValueNotifier<List<Person>>([]);

  Future<void> refresh() async {
    members.value = await _membersRepository.getAll();
  }
}
