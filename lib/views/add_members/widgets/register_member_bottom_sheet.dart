import 'package:flutter/material.dart';
import 'package:splitus/core/field_validators.dart';
import 'package:splitus/models/member.dart';
import 'package:uuid/uuid.dart';

Future<Person?> showRegisterMemberBottomSheet(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => const RegisterMemberBottomSheet(),
  );
}

class RegisterMemberBottomSheet extends StatefulWidget {
  const RegisterMemberBottomSheet({super.key});

  @override
  State<RegisterMemberBottomSheet> createState() => _RegisterMemberBottomSheetState();
}

class _RegisterMemberBottomSheetState extends State<RegisterMemberBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldController = TextEditingController();

  @override
  void dispose() {
    _nameFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    iconSize: 24,
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
              const Text(
                'Adicione mais um coitado para dividir a conta:',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameFieldController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  label: Text("Nome"),
                  border: OutlineInputBorder(),
                ),
                validator: FieldValidators.isRequired(),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final member = Person(id: const Uuid().v4(), name: _nameFieldController.text.trim());
                    Navigator.of(context).pop(member);
                  }
                },
                child: const Text('Adicionar'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
