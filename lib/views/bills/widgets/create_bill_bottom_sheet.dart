import 'package:flutter/material.dart';
import 'package:splitus/models/bill.dart';
import 'package:uuid/uuid.dart';

Future<Bill?> showCreateBillBottomSheet(BuildContext context) async {
  return showModalBottomSheet<Bill>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const CreateBillBottomSheet(),
  );
}

class CreateBillBottomSheet extends StatefulWidget {
  const CreateBillBottomSheet({super.key});

  @override
  State<CreateBillBottomSheet> createState() => _CreateBillBottomSheetState();
}

class _CreateBillBottomSheetState extends State<CreateBillBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fieldController = TextEditingController();

  @override
  void dispose() {
    _fieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _fieldController,
              decoration: const InputDecoration(
                label: Text('Nome da comanda'),
                hintText: "Meu restanrante preferido....",
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final newBill = Bill(
                    id: const Uuid().v4(),
                    name: _fieldController.text.trim(),
                    createdAt: DateTime.now(),
                    membersIds: [],
                  );
                  Navigator.of(context).pop(newBill);
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
