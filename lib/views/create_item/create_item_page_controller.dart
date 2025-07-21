import 'package:flutter/foundation.dart';
import 'package:saporra/models/member.dart';
import 'package:saporra/repositories/members_repository.dart';
import 'package:saporra/services/local_storage_service.dart';

class CreateItemPageController {
  final _membersRepository = MembersRepository(LocalStorageService());
  final currentMembers = ValueNotifier<List<Person>>([]);
  final members = ValueNotifier<List<Person>>([]);

  Future<void> getMembers() async {
    members.value = await _membersRepository.getAll();
  }
}
