import 'package:flutter/material.dart';
import 'package:busmate/utils/global.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_model.dart';
import '../info_account.dart';
import '../choose_role.dart';

class InforTeacher extends StatelessWidget {
  final User? user;

  const InforTeacher({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () async {},
            child: InfoAccount(
              user: user!,
            )));
    /*
      Center(
      child: IntrinsicHeight(
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
      ),
    );

     */
  }
}
