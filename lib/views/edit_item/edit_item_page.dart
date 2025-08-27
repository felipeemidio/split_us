import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitus/core/errors/app_exception.dart';
import 'package:splitus/core/field_validators.dart';
import 'package:splitus/core/formatters/currency_formatter.dart';
import 'package:splitus/core/formatters/text_formatter.dart';
import 'package:splitus/core/utils/app_snackbar_utils.dart';
import 'package:splitus/models/shop_item.dart';
import 'package:splitus/views/add_members/widgets/add_new_member_button.dart';
import 'package:splitus/views/bill_detail/views/cart_items/widgets/checkable_member_card.dart';
import 'package:splitus/views/edit_item/edit_item_page_controller.dart';

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
  final _quantityFieldController = TextEditingController();
  final _priceFieldController = TextEditingController();
  bool noMemberError = false;

  @override
  void initState() {
    super.initState();
    _controller.loadInitialData(widget.currentItem);
    _nameFieldController.text = widget.currentItem.name;
    _quantityFieldController.text = widget.currentItem.quantity.toString();
    _priceFieldController.text = TextFormatter.currency(widget.currentItem.price, '');
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _quantityFieldController.dispose();
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
        quantity: int.tryParse(_quantityFieldController.text.trim()) ?? 1,
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
                        ValueListenableBuilder(
                          valueListenable: _quantityFieldController,
                          builder: (context, textValue, child) {
                            final value = int.tryParse(_quantityFieldController.text) ?? 0;
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap:
                                      value > 1 ? () => _quantityFieldController.text = (value - 1).toString() : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: value > 1
                                          ? Theme.of(context).colorScheme.primaryContainer
                                          : Theme.of(context).disabledColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(Icons.remove,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: value > 1 ? 1 : 0.5)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 80,
                                  child: TextFormField(
                                    controller: _quantityFieldController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      label: Text('Qtde'),
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLength: 3,
                                    buildCounter: (context,
                                            {required currentLength, required isFocused, required maxLength}) =>
                                        null,
                                    validator: FieldValidators.isRequired(),
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    _quantityFieldController.text = (value + 1).toString();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _priceFieldController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          buildCounter: (context, {required currentLength, required isFocused, required maxLength}) =>
                              null,
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
                        Row(
                          children: [
                            const Text(
                              "TOTAL",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            ValueListenableBuilder(
                                valueListenable: _quantityFieldController,
                                builder: (context, quantity, child) {
                                  return ValueListenableBuilder(
                                      valueListenable: _priceFieldController,
                                      builder: (context, price, child) {
                                        final total = TextFormatter.currencyToValue(price.text.trim()) *
                                            (int.tryParse(quantity.text.trim()) ?? 1);
                                        return Text(
                                          'R\$ ${TextFormatter.currency(total, '')} ',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      });
                                }),
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
