import 'package:flutter/material.dart';
import 'package:splitus/models/member.dart';

class AppAvatarMemberCircle extends StatelessWidget {
  final Person member;
  const AppAvatarMemberCircle({super.key, required this.member});

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> parts = name.split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(child: Text(_getInitials(member.name)));
  }
}
