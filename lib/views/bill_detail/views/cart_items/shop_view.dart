import 'package:flutter/material.dart';
import 'package:splitus/core/consts/app_routes.dart';
import 'package:splitus/core/formatters/text_formatter.dart';
import 'package:splitus/models/bill.dart';
import 'package:splitus/models/shop_item.dart';
import 'package:splitus/views/bill_detail/views/cart_items/widgets/cart_item_card.dart';
import 'package:splitus/widgets/page_template.dart';

class ShopView extends StatelessWidget {
  final Bill bill;
  final List<ShopItem> cart;
  final double total;
  final void Function(ShopItem item) onEditItem;
  final void Function(ShopItem item) onAddItem;
  final void Function(ShopItem item) onDeleteItem;
  const ShopView({
    super.key,
    required this.bill,
    required this.cart,
    required this.onEditItem,
    required this.onAddItem,
    required this.onDeleteItem,
    this.total = 0,
  });

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: bill.name,
      subtitle: "Itens",
      trailing: Text(TextFormatter.currency(total, 'R\$')),
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

          return ListView.builder(
            itemCount: cart.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
            itemBuilder: (context, index) {
              final item = cart[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CartItemCard(
                  item: item,
                  onDelete: () => onDeleteItem(item),
                  onTap: () async {
                    final editedItem = await Navigator.of(context).pushNamed(
                      AppRoutes.editItem,
                      arguments: item,
                    );
                    if (editedItem is ShopItem) {
                      onEditItem(editedItem);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.of(context).pushNamed(
            AppRoutes.createItem,
            arguments: bill,
          );

          if (newItem is ShopItem) {
            onAddItem(newItem);
          }
        },
        tooltip: 'Adicionar item',
        child: const Icon(Icons.add_shopping_cart_rounded),
      ),
    );
  }
}
