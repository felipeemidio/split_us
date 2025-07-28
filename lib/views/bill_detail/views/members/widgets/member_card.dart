import 'package:flutter/material.dart';
import 'package:splitus/core/extensions/currency_extension.dart';
import 'package:splitus/models/member.dart';
import 'package:splitus/widgets/app_avatar_member_circle.dart';

class MemberCard extends StatelessWidget {
  final Person member;
  final double ownedAmount;
  const MemberCard({
    super.key,
    required this.member,
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
          AppAvatarMemberCircle(member: member),
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
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
