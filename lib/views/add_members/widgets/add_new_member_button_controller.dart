import 'package:saporra/models/member.dart';
import 'package:saporra/repositories/members_repository.dart';
import 'package:saporra/services/local_storage_service.dart';

class AddNewMemberButtonController {
  final _membersRepository = MembersRepository(LocalStorageService());

  Future<void> addMember(Person member) async {
    await _membersRepository.add(member);
  }
}
