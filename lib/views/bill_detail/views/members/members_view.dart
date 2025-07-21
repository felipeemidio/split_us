import 'package:flutter/material.dart';
import 'package:saporra/core/consts/app_routes.dart';
import 'package:saporra/core/utils/app_snackbar_utils.dart';
import 'package:saporra/models/bill.dart';
import 'package:saporra/models/member.dart';
import 'package:saporra/models/shop_item.dart';
import 'package:saporra/views/bill_detail/views/members/member_view_controller.dart';
import 'package:saporra/views/bill_detail/views/members/widgets/member_card.dart';

class MembersView extends StatefulWidget {
  final Bill bill;
  final List<ShopItem> items;

  const MembersView({
    super.key,
    required this.items,
    required this.bill,
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

  _getBillMembers() {}

  @override
  void initState() {
    super.initState();
    controller.initialize(widget.bill, widget.items);
  }

  Future<void> _onDeleteMember(BuildContext context, Person member) async {
    final memberAmount = _calcOwnedAmount(member);
    if (memberAmount > 0) {
      AppSnackbarUtils.error(context, message: 'Não é possivel remover um membro devedor.');
    }
    try {
      await controller.onDeleteMember(widget.bill, member);
    } catch (e) {
      if (context.mounted) {
        String message = 'Houve um erro ao remover "${member.name}".';
        AppSnackbarUtils.error(context, message: message);
      }
    }
  }

  Future<void> _onAddMembers(BuildContext context) async {
    try {
      final newMembers = await Navigator.of(context).pushNamed(AppRoutes.createMember);
      if (context.mounted && newMembers != null && newMembers is List<Person> && newMembers.isNotEmpty) {
        await controller.onAddMembers(widget.bill, newMembers);
      }
    } catch (e, st) {
      print(e);
      print(st);
      if (context.mounted) {
        String message = 'Houve um erro ao adicionar novos membros à comanda.';
        AppSnackbarUtils.error(context, message: message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Não há membros!\nColoque algém para pagar a conta!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MemberCard(
                    member: member,
                    ownedAmount: _calcOwnedAmount(member),
                    onDelete: () => _onDeleteMember(context, member),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddMembers(context),
        tooltip: 'Adicionar membro',
        child: const Icon(Icons.person_add_alt_1),
      ),
    );
  }
}
