import 'package:flutter/material.dart';
import 'package:saporra/models/member.dart';
import 'package:saporra/widgets/app_card.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  const PersonCard({
    super.key,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 16),
          Text(person.name),
        ],
      ),
    );
  }
}
