import 'package:flutter/material.dart';
import 'package:saporra/core/consts/app_routes.dart';
import 'package:saporra/models/bill.dart';
import 'package:saporra/models/member.dart';
import 'package:saporra/models/shop_item.dart';
import 'package:saporra/views/bill_detail/views/cart_items/widgets/cart_item_card.dart';

class ShopView extends StatelessWidget {
  final Bill bill;
  final List<ShopItem> cart;
  final List<Person> members;
  final void Function(ShopItem item) onAddItem;
  final void Function(ShopItem item) onDeleteItem;
  const ShopView({
    super.key,
    required this.bill,
    required this.cart,
    required this.members,
    required this.onAddItem,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (cart.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.remove_shopping_cart, size: 64),
                    SizedBox(height: 24),
                    Text(
                      'Não há itens!\nCompre alguma coisa e divida com os amigos!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CartItemCard(
                    item: item,
                    onDelete: () => onDeleteItem(item),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // if (members.isEmpty) {
          //   showWarningDialog(
          //     context,
          //     title: 'Não há membros!',
          //     description: 'Inscreva membros para dividir a conta dos produtos.',
          //   );
          //   return;
          // }

          final newItem = await Navigator.of(context).pushNamed(
            AppRoutes.createItem,
            arguments: bill,
          );

          if (newItem != null && newItem is ShopItem) {
            onAddItem(newItem);
          }
        },
        tooltip: 'Adicionar item',
        child: const Icon(Icons.add_shopping_cart_rounded),
      ),
    );
  }
}
