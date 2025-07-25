import 'package:flutter/material.dart';
import 'package:splitus/core/utils/app_snackbar_utils.dart';
import 'package:splitus/models/member.dart';
import 'package:splitus/views/add_members/widgets/add_new_member_button_controller.dart';
import 'package:splitus/views/add_members/widgets/register_member_bottom_sheet.dart';

class AddNewMemberButton extends StatefulWidget {
  final void Function(Person member) onAddMember;
  const AddNewMemberButton({super.key, required this.onAddMember});

  @override
  State<AddNewMemberButton> createState() => _AddNewMemberButtonState();
}

class _AddNewMemberButtonState extends State<AddNewMemberButton> {
  final controlller = AddNewMemberButtonController();

  _onOpenMemberForm(BuildContext context) async {
    try {
      final newPerson = await showRegisterMemberBottomSheet(context);
      FocusManager.instance.primaryFocus?.unfocus();
      if (newPerson != null) {
        await controlller.addMember(newPerson);
        widget.onAddMember(newPerson);
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackbarUtils.error(context, message: 'Houve um erro ao adicionar membro.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onOpenMemberForm(context),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              "Cadastrar nova pessoa",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
