import 'package:flutter/material.dart';
import 'package:saporra/core/errors/app_exception.dart';
import 'package:saporra/core/field_validators.dart';
import 'package:saporra/core/formatters/currency_formatter.dart';
import 'package:saporra/core/formatters/text_formatter.dart';
import 'package:saporra/core/utils/app_snackbar_utils.dart';
import 'package:saporra/models/shop_item.dart';
import 'package:saporra/views/add_members/widgets/add_new_member_button.dart';
import 'package:saporra/views/bill_detail/views/cart_items/widgets/checkable_member_card.dart';
import 'package:saporra/views/edit_item/edit_item_page_controller.dart';

class EditItemPage extends StatefulWidget {
  final ShopItem currentItem;
  const EditItemPage({super.key, required this.currentItem});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = EditItemPageController();
  final _nameFieldController = TextEditingController();
  final _priceFieldController = TextEditingController();
  bool noMemberError = false;

  @override
  void initState() {
    super.initState();
    _controller.loadInitialData(widget.currentItem);
    _nameFieldController.text = widget.currentItem.name;
    _priceFieldController.text = TextFormatter.currency(widget.currentItem.price, '');
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _priceFieldController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_controller.currentMembers.value.isEmpty) {
        setState(() {
          noMemberError = true;
        });
        return;
      }
      final cartItem = ShopItem(
        id: widget.currentItem.id,
        name: _nameFieldController.text.trim(),
        price: TextFormatter.currencyToValue(_priceFieldController.text.trim()),
        billId: widget.currentItem.billId,
        payersIds: _controller.currentMembers.value.map((member) => member.id).toList(),
      );

      try {
        await _controller.onEditItem(cartItem);
        if (context.mounted) {
          Navigator.of(context).pop(cartItem);
        }
      } catch (e) {
        if (context.mounted) {
          AppSnackbarUtils.error(context, message: e is AppException ? e.message : 'Não foi possível salvar os dados');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Item'),
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
              ValueListenableBuilder(
                valueListenable: _controller.isLoading,
                builder: (context, isLoading, child) {
                  return FilledButton(
                    onPressed: isLoading ? null : () => _onSubmit(context),
                    child: child,
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_shopping_cart_outlined),
                    SizedBox(width: 8),
                    Text('Editar item'),
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
