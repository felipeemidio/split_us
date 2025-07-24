import 'package:flutter/material.dart';
import 'package:saporra/models/member.dart';
import 'package:saporra/widgets/app_card.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final VoidCallback onRemove;
  const PersonCard({
    super.key,
    required this.person,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 16),
          Expanded(child: Text(person.name)),
          const SizedBox(width: 16),
          SizedBox(
            height: 24,
            width: 24,
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 24,
              color: Theme.of(context).colorScheme.error,
              icon: const Icon(Icons.delete_outlined),
              onPressed: onRemove,
            ),
          )
        ],
      ),
    );
  }
}
