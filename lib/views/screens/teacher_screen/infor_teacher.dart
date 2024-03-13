import 'package:flutter/material.dart';
import 'package:school_bus_attendance_test/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_model.dart';
import '../choose_role.dart';

class InforTeacher extends StatelessWidget {
  final User? user;

  const InforTeacher({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("information of ${user?.userName}"),
          ElevatedButton(
              onPressed: () async {
                // await secureStorage.delete(key: "key_username");
                // await secureStorage.delete(key: "key_roleId");
                // await secureStorage.delete(key: "key_userId");
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.clear();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => ChoosingRole()));
              },
              child: Text("Log out"))
        ],
      ),
    );
  }
}
