import 'package:flutter/material.dart';
import 'package:splitus/core/field_validators.dart';
import 'package:splitus/core/formatters/currency_formatter.dart';
import 'package:splitus/core/formatters/text_formatter.dart';
import 'package:splitus/models/bill.dart';
import 'package:splitus/models/shop_item.dart';
import 'package:splitus/views/add_members/widgets/add_new_member_button.dart';
import 'package:splitus/views/bill_detail/views/cart_items/widgets/checkable_member_card.dart';
import 'package:splitus/views/create_item/create_item_page_controller.dart';
import 'package:uuid/uuid.dart';

class CreateItemPage extends StatefulWidget {
  final Bill currentBill;
  const CreateItemPage({super.key, required this.currentBill});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = CreateItemPageController();
  final _nameFieldController = TextEditingController();
  final _priceFieldController = TextEditingController();
  bool noMemberError = false;

  @override
  void initState() {
    super.initState();
    _controller.getMembers();
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _priceFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Item'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameFieldController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            label: Text('Descrição'),
                            border: OutlineInputBorder(),
                          ),
                          validator: FieldValidators.isRequired(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _priceFieldController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text('Valor'),
                            border: OutlineInputBorder(),
                            prefix: Text('R\$ '),
                          ),
                          validator: FieldValidators.isRequired(),
                          inputFormatters: [
                            CurrencyInputFormatter(),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Membros',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        if (noMemberError)
                          Text(
                            'Selecione 1 ou mais membros',
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        const SizedBox(height: 8),
                        ValueListenableBuilder(
                          valueListenable: _controller.members,
                          builder: (context, members, _) {
                            return ValueListenableBuilder(
                              valueListenable: _controller.currentMembers,
                              builder: (context, currentMembers, _) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: members.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: AddNewMemberButton(
                                          onAddMember: _controller.onAddMember,
                                        ),
                                      );
                                    }
                                    final member = members[index - 1];
                                    final isCheck = currentMembers.contains(member);
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: CheckableMemberCard(
                                        member: member,
                                        check: isCheck,
                                        onCheck: (value) {
                                          if (noMemberError) {
                                            noMemberError = false;
                                          }

                                          if (isCheck) {
                                            _controller.currentMembers.value.remove(member);
                                          } else {
                                            _controller.currentMembers.value.add(member);
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (_controller.currentMembers.value.isEmpty) {
                      setState(() {
                        noMemberError = true;
                      });
                      return;
                    }
                    final cartItem = ShopItem(
                      id: const Uuid().v4(),
                      name: _nameFieldController.text.trim(),
                      price: TextFormatter.currencyToValue(_priceFieldController.text.trim()),
                      billId: widget.currentBill.id,
                      payersIds: _controller.currentMembers.value.map((member) => member.id).toList(),
                    );

                    Navigator.of(context).pop(cartItem);
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_shopping_cart_outlined),
                    SizedBox(width: 8),
                    Text('Adicionar item'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
