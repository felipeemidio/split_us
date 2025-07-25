import 'package:splitus/models/member.dart';
import 'package:splitus/repositories/members_repository.dart';
import 'package:splitus/services/local_storage_service.dart';

class AddNewMemberButtonController {
  final _membersRepository = MembersRepository(LocalStorageService());

  Future<void> addMember(Person member) async {
    await _membersRepository.add(member);
  }
}
