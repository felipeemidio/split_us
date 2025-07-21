import 'package:flutter/material.dart';
import 'package:saporra/views/add_members/add_members_page_controller.dart';
import 'package:saporra/views/add_members/widgets/add_new_member_button.dart';
import 'package:saporra/views/add_members/widgets/person_card.dart';

class AddMembersPage extends StatefulWidget {
  const AddMembersPage({super.key});

  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {
  final controller = AddMembersPageController();

  @override
  void initState() {
    super.initState();
    controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Membros"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder(
          valueListenable: controller.members,
          builder: (context, members, _) {
            return ListView.builder(
              itemCount: members.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AddNewMemberButton(onAddMember: (person) => controller.refresh()),
                  );
                }
                final member = members[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: PersonCard(person: member),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
