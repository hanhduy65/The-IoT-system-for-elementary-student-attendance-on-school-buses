import 'package:flutter/material.dart';
import 'package:school_bus_attendance_test/views/screens/register_screen.dart';

import '../../../models/user_model.dart';

class HomeManager extends StatefulWidget {
  final User? user;
  const HomeManager({super.key, this.user});

  @override
  State<HomeManager> createState() => _HomeManagerState();
}

class _HomeManagerState extends State<HomeManager> {
  @override
  Widget build(BuildContext context) {
    return RegisterScreen();
  }
}
