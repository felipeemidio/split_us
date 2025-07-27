import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitus/core/consts/app_routes.dart';
import 'package:splitus/core/theme/colors.dart';
import 'package:splitus/models/bill.dart';
import 'package:splitus/models/shop_item.dart';
import 'package:splitus/views/add_members/add_members_page.dart';
import 'package:splitus/views/bill_detail/bill_detail_page.dart';
import 'package:splitus/views/bills/bills_page.dart';
import 'package:splitus/views/create_item/create_item_page.dart';
import 'package:splitus/views/edit_item/edit_item_page.dart';

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

    final themeColors = AppColors.blueLightTheme;
    return MaterialApp(
      title: 'SplitUs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: themeColors,
        scaffoldBackgroundColor: themeColors.surface,
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
