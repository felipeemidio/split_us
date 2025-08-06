import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:splitus/core/app_env.dart';
import 'package:splitus/core/consts/app_routes.dart';
import 'package:splitus/core/utils/app_snackbar_utils.dart';
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
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  double get _horizontalTitlePadding {
    const kCollapsedPadding = 60.0;

    if (_scrollController.hasClients) {
      return min(_kBasePadding + kCollapsedPadding,
          _kBasePadding + (kCollapsedPadding * _scrollController.offset) / (kExpandedHeight - kToolbarHeight));
    }

    return _kBasePadding;
  }

  final controller = BillsPageController();

  _createNewBill(BuildContext context) async {
    final newBill = await showCreateBillBottomSheet(context);
    if (newBill != null) {
      await controller.createBill(newBill);
      if (context.mounted) {
        AppSnackbarUtils.info(context, message: "Nova conta criada com sucesso");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller.initialize();
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeAd());
  }

  Future<void> _initializeAd() async {
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );
    if (size == null) {
      return;
    }

    _bannerAd = BannerAd(
      size: size,
      adUnitId: AppEnv.unitAdId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          print("AdError $error");
        },
      ),
      request: const AdRequest(),
    );

    _bannerAd.load();
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
      title: 'Comandas',
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.createMember),
          icon: const Icon(Icons.person_add),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewBill(context),
        tooltip: 'Criar uma nova comanda',
        child: const Icon(Icons.receipt_long_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: bills.length + 1,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == bills.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _isAdLoaded
                        ? SizedBox(
                            width: _bannerAd.size.width.toDouble(),
                            height: _bannerAd.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd),
                          )
                        : Container(),
                  );
                }
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
