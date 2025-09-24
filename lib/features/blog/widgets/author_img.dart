import 'package:flutter/material.dart';

class AuthorImg extends StatelessWidget {
  const AuthorImg({
    super.key,
    required this.authorImg,
  });

  final String authorImg;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: Colors.grey[400],
      backgroundImage: authorImg.isNotEmpty
          ? NetworkImage(authorImg)
          : null,
      child: authorImg.isEmpty
          ? const Icon(
        Icons.person,
        size: 14,
        color: Colors.white,
      )
          : null,
    );
  }
}