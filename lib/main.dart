import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saporra/core/consts/app_routes.dart';
import 'package:saporra/models/bill.dart';
import 'package:saporra/models/shop_item.dart';
import 'package:saporra/views/add_members/add_members_page.dart';
import 'package:saporra/views/bill_detail/bill_detail_page.dart';
import 'package:saporra/views/bills/bills_page.dart';
import 'package:saporra/views/create_item/create_item_page.dart';
import 'package:saporra/views/edit_item/edit_item_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // LocalStorageService().clear();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'App Sáporra',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        scaffoldBackgroundColor: Colors.amber.shade50,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.bills,
      routes: {
        AppRoutes.bills: (context) => const BillsPage(),
        AppRoutes.billDetail: (context) =>
            BillDetailPage(currentBill: ModalRoute.of(context)!.settings.arguments as Bill),
        AppRoutes.createItem: (context) => CreateItemPage(
              currentBill: ModalRoute.of(context)!.settings.arguments as Bill,
            ),
        AppRoutes.editItem: (context) => EditItemPage(
              currentItem: ModalRoute.of(context)!.settings.arguments as ShopItem,
            ),
        AppRoutes.createMember: (context) => const AddMembersPage(),
      },
    );
  }
}
