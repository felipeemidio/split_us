import 'package:flutter/material.dart';
import 'package:splitus/core/formatters/text_formatter.dart';
import 'package:splitus/models/bill.dart';
import 'package:splitus/models/member.dart';
import 'package:splitus/models/shop_item.dart';
import 'package:splitus/views/bill_detail/views/members/member_view_controller.dart';
import 'package:splitus/views/bill_detail/views/members/widgets/member_card.dart';
import 'package:splitus/widgets/page_template.dart';

class MembersView extends StatefulWidget {
  final Bill bill;
  final double total;
  final List<ShopItem> items;

  const MembersView({
    super.key,
    required this.items,
    required this.bill,
    this.total = 0,
  });

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  final controller = MemberViewController();

  double _calcOwnedAmount(Person member) {
    double total = 0;
    for (final item in widget.items) {
      if (item.payersIds.contains(member.id)) {
        total += (item.price / item.payersIds.length);
      }
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    controller.initialize(widget.bill, widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: widget.bill.name,
      subtitle: "Membros",
      trailing: Text(TextFormatter.currency(widget.total, 'R\$')),
      body: ValueListenableBuilder(
        valueListenable: controller.members,
        builder: (context, members, _) {
          if (members.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_off, size: 64),
                    SizedBox(height: 24),
                    Text(
                      'Ainda não há membros!\nAdicione itens e divida com os amigos para ver os membros desta comanda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: members.length,
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final member = members[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MemberCard(
                  member: member,
                  ownedAmount: _calcOwnedAmount(member),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
