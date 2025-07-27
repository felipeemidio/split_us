import 'package:flutter/material.dart';
import 'package:splitus/models/bill.dart';
import 'package:splitus/views/bill_detail/bill_detail_page_controller.dart';
import 'package:splitus/views/bill_detail/views/members/members_view.dart';
import 'package:splitus/views/bill_detail/views/cart_items/shop_view.dart';

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
    _controller.getItems(widget.currentBill);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavIndex,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        selectedItemColor: Theme.of(context).colorScheme.primary,
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
                total: _controller.total,
                onEditItem: (newItem) {
                  _controller.getItems(widget.currentBill);
                },
                onAddItem: (newItem) {
                  _controller.addItem(newItem, widget.currentBill);
                },
                onDeleteItem: (newItem) {
                  _controller.removeItem(newItem, widget.currentBill);
                },
              ),
              MembersView(
                items: items,
                bill: widget.currentBill,
              ),
            ],
          );
        },
      ),
    );
  }
}
