import 'package:flutter/material.dart';
import 'package:splitus/core/consts/app_routes.dart';
import 'package:splitus/core/formatters/text_formatter.dart';
import 'package:splitus/models/bill.dart';
import 'package:splitus/widgets/app_card.dart';

class BillCard extends StatelessWidget {
  final Bill bill;
  final void Function() onDelete;
  const BillCard({
    super.key,
    required this.bill,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.billDetail, arguments: bill);
        },
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                bill.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Criado em: ${TextFormatter.dateToddMMyyyyHmm(bill.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
