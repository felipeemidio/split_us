import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:splitus/core/consts/app_local_storage_keys.dart';
import 'package:splitus/core/consts/app_routes.dart';
import 'package:splitus/services/local_storage_service.dart';
import 'package:splitus/views/bills/bills_page_controller.dart';
import 'package:splitus/views/bills/widgets/bill_card.dart';
import 'package:splitus/views/bills/widgets/create_bill_bottom_sheet.dart';

class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  final controller = BillsPageController();

  _createNewBill() async {
    final newBill = await showCreateBillBottomSheet(context);
    if (newBill != null) {
      final newList = [...controller.bills.value, newBill];
      final newRawList = newList.map((e) => e.toMap()).toList();
      await LocalStorageService().write(AppLocalStorageKeys.bills, jsonEncode(newRawList));
      controller.bills.value = newList;
    }
  }

  @override
  void initState() {
    super.initState();
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comandas'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (option) {
              if (option == 'Gerenciar membros') {
                Navigator.of(context).pushNamed(AppRoutes.createMember);
              }
            },
            // surfaceTintColor: Colors.red,
            color: Theme.of(context).colorScheme.primaryContainer,
            itemBuilder: (BuildContext context) {
              return {'Gerenciar membros', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewBill,
        tooltip: 'Criar uma nova comanda',
        child: const Icon(Icons.receipt_long_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: ValueListenableBuilder(
          valueListenable: controller.bills,
          builder: (context, bills, child) {
            if (bills.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.remove_shopping_cart, size: 64),
                      SizedBox(height: 24),
                      Text(
                        'Nenhum comanda cadastrada.\nCrie uma e comece a dividir suas contas!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: bills.length,
              itemBuilder: (context, index) {
                final bill = bills[index];
                return BillCard(
                  bill: bill,
                  onDelete: () => controller.deleteBill(bill),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
