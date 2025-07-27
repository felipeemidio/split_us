import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:splitus/core/consts/app_local_storage_keys.dart';
import 'package:splitus/services/local_storage_service.dart';
import 'package:splitus/views/bills/bills_page_controller.dart';
import 'package:splitus/views/bills/widgets/bill_card.dart';
import 'package:splitus/views/bills/widgets/create_bill_bottom_sheet.dart';
import 'package:splitus/widgets/page_template.dart';

class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  static const _kBasePadding = 16.0;
  static const kExpandedHeight = 250.0;
  final ValueNotifier<double> _titlePaddingNotifier = ValueNotifier(_kBasePadding);
  final _scrollController = ScrollController();

  double get _horizontalTitlePadding {
    const kCollapsedPadding = 60.0;

    if (_scrollController.hasClients) {
      return min(_kBasePadding + kCollapsedPadding,
          _kBasePadding + (kCollapsedPadding * _scrollController.offset) / (kExpandedHeight - kToolbarHeight));
    }

    return _kBasePadding;
  }

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

    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });
  }

  @override
  void dispose() {
    _titlePaddingNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewBill,
        tooltip: 'Criar uma nova comanda',
        child: const Icon(Icons.receipt_long_outlined),
      ),
      title: 'Comandas',
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
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
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final bill = bills[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: BillCard(
                    bill: bill,
                    onDelete: () => controller.deleteBill(bill),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
