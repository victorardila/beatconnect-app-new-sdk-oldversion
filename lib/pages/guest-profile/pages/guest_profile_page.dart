import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:beatconnect_launch_mvp/lib.dart';

class GuestProfilePage extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> guest;
  const GuestProfilePage({super.key, required this.guest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileView(
        guest: guest,
      ),
    );
  }
}
