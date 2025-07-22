import 'package:flutter/material.dart';
import 'package:saporra/models/bill.dart';
import 'package:saporra/views/bill_detail/bill_detail_page_controller.dart';
import 'package:saporra/views/bill_detail/views/members/members_view.dart';
import 'package:saporra/views/bill_detail/views/cart_items/shop_view.dart';

class BillDetailPage extends StatefulWidget {
  final Bill currentBill;
  const BillDetailPage({super.key, required this.currentBill});

  @override
  State<BillDetailPage> createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  final _controller = BillDetailPageController();
  final _pageViewController = PageController();
  int bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.getItems();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.currentBill.name),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavIndex,
        onTap: (index) async {
          setState(() {
            bottomNavIndex = index;
          });
          await _pageViewController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: "Itens",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group),
            label: "Membros",
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: _controller.items,
          builder: (context, items, _) {
            return PageView(
              controller: _pageViewController,
              onPageChanged: (index) {
                setState(() {
                  bottomNavIndex = index;
                });
              },
              children: [
                ShopView(
                  bill: widget.currentBill,
                  cart: items,
                  members: [],
                  onAddItem: (newItem) {
                    setState(() {
                      items.add(newItem);
                    });
                  },
                  onDeleteItem: (newItem) {
                    setState(() {
                      items.remove(newItem);
                    });
                  },
                ),
                MembersView(
                  items: items,
                  bill: widget.currentBill,
                ),
              ],
            );
          }),
    );
  }
}
