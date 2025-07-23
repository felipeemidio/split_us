import 'package:flutter/material.dart';
import 'package:saporra/models/member.dart';

class CheckableMemberCard extends StatelessWidget {
  final Person member;
  final bool check;
  final void Function(bool? value) onCheck;
  const CheckableMemberCard({
    super.key,
    required this.member,
    required this.check,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCheck(!check),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: Theme.of(context).primaryColor.withOpacity(check ? 1 : 0.4),
          ),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 2,
              spreadRadius: 1,
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox.adaptive(
                value: check,
                onChanged: onCheck,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                member.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: check ? FontWeight.w500 : FontWeight.w400,
                  color: check ? Theme.of(context).primaryColor : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
