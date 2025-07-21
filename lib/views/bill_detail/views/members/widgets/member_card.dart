import 'package:flutter/material.dart';
import 'package:saporra/core/extensions/currency_extension.dart';
import 'package:saporra/models/member.dart';

class MemberCard extends StatelessWidget {
  final Person member;
  final double ownedAmount;
  final void Function() onDelete;
  const MemberCard({
    super.key,
    required this.member,
    required this.onDelete,
    this.ownedAmount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 1,
            color: Colors.black26,
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              member.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            ownedAmount.brl(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 20,
            height: 20,
            child: IconButton(
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              iconSize: 20,
              color: Colors.red.shade700,
              icon: const Icon(Icons.delete_outline),
            ),
          ),
        ],
      ),
    );
  }
}
