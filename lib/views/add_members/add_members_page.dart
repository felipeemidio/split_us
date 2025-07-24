import 'package:flutter/material.dart';
import 'package:saporra/views/add_members/add_members_page_controller.dart';
import 'package:saporra/views/add_members/widgets/add_new_member_button.dart';
import 'package:saporra/views/add_members/widgets/person_card.dart';
import 'package:saporra/widgets/warning_dialog.dart';

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
        title: const Text("Gerenciar Membros"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ValueListenableBuilder(
          valueListenable: controller.isLoadingRemoval,
          builder: (context, isLoading, _) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: ValueListenableBuilder(
                    valueListenable: controller.members,
                    builder: (context, members, _) {
                      return ListView.builder(
                        itemCount: members.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
                              child: AddNewMemberButton(onAddMember: (person) => controller.refresh()),
                            );
                          }
                          final member = members[index - 1];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
                            child: PersonCard(
                              person: member,
                              onRemove: () async {
                                final pendentBill = await controller.removeMember(member);
                                if (pendentBill != null && context.mounted) {
                                  showWarningDialog(
                                    context,
                                    title: 'Usuário participa da comanda "${pendentBill.name}"',
                                    description:
                                        "Não é possivel deletar o usuário enquanto ele estiver participando de alguma comanda.",
                                  );
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                if (isLoading) ...[
                  const Opacity(
                    opacity: 0.5,
                    child: ModalBarrier(
                      dismissible: false,
                      color: Colors.black54,
                    ),
                  ),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ],
            );
          }),
    );
  }
}
