import 'package:flutter/material.dart';

void showLoginPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Login Required",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: const Text(
          "You need to log in to post a blog.\n Please login to continue. ",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Poppins",
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // cancel
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // popup বন্ধ
              Navigator.pushNamed(context, '/sign-in');
            },
            child: const Text("Login"),
          ),
        ],
      );
    },
  );
}
