import 'package:busmate/views/screens/info_account.dart';
import 'package:busmate/views/screens/parent_screen/choosing_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import 'choose_role_remake.dart';

class AccountScreen extends StatelessWidget {
  final User? user;
  final String? stuId;
  const AccountScreen({super.key, this.user, this.stuId});

  @override
  Widget build(BuildContext context) {
    final circleRadius = 136.0;

    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ombre_blue.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            children: [
              SizedBox(height: 40.h),
              IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                        width: circleRadius,
                        height: circleRadius,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                  blurRadius: 10.0,
                                  offset: const Offset(0.0, 5.0))
                            ]),
                        child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/image_avt/avt_parent.jpg'))))),
                    SizedBox(height: 16.h),
                    Text(
                      user?.fullName?.toUpperCase() ?? " ",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InfoAccount(
                              user: user,
                            )),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Thiết lập bo tròn cho Card
                  ),
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.red,
                      ),
                      title: Text("View profile"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlaceAPIGoogleMapSearch(
                              stuId: stuId,
                            )),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Thiết lập bo tròn cho Card
                  ),
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Colors.blueAccent,
                      ),
                      title: Text("Add pick-up/drop-off locations"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Thiết lập bo tròn cho Card
                ),
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      Icons.add_comment_outlined,
                      color: Colors.green,
                    ),
                    title: Text("Give us feedback"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Thiết lập bo tròn cho Card
                ),
                color: Theme.of(context).colorScheme.secondary,
                surfaceTintColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: IntrinsicWidth(
                      child: ListTile(
                        leading: Icon(
                          Icons.power_settings_new,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Logout"),
                              content: Text("Are you sure you want to logout?"),
                              actions: <Widget>[
                                // Nút Cancel
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Đóng popup
                                  },
                                  child: Text("Cancel"),
                                ),
                                // Nút Logout
                                TextButton(
                                  onPressed: () async {
                                    SharedPreferences sp =
                                        await SharedPreferences.getInstance();
                                    sp.remove("isLogin");
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                ChooseRoleRemake()));
                                  },
                                  child: Text("Logout"),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h)
            ],
          ),
        ),
      ),
    );
  }
}
