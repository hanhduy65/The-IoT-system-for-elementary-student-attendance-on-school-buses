import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/user_model.dart';

class MainScreenTeacher extends StatefulWidget {
  final User? user;
  final int? busId;
  const MainScreenTeacher({super.key, this.user, this.busId});

  @override
  State<MainScreenTeacher> createState() => _MainScreenTeacherState();
}

class _MainScreenTeacherState extends State<MainScreenTeacher> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 1.sw,
          height: 1.sh,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/ombre_blue.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, teacher",
                    style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                  ),
                  Text(
                    widget.user?.fullName ?? "",
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: AssetImage("assets/image_avt/avt.jpg"),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Image.asset(
                  "assets/images/FPT_University.jpg",
                  height: 1.sh * 0.25,
                  width: 1.sw,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "Information today",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Card(
                          color: Color(0xFFFDF8E2),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/icons/icon_bus.png",
                                  width: 60,
                                  height: 60,
                                ),
                                Text(
                                  "License id",
                                  style: TextStyle(
                                    color: Color(0xFFECAB33),
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text("17B - 17026",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          color: Color(0xFFFFE3D3),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Image.asset(
                                      "assets/icons/icon_driver.png",
                                      width: 60,
                                      height: 60,
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Image.asset(
                                        "assets/icons/icon_call.png",
                                        width: 18,
                                        height: 18,
                                        color: Color(0xFFEC6F0D),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "Call driver",
                                  style: TextStyle(
                                    color: Color(0xFFDC7D32),
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text("Ngô Văn Long",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          color: Color(0xFFE3FFD8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/icons/icon_children.png",
                                  width: 60,
                                ),
                                Text(
                                  "Quantity",
                                  style: TextStyle(
                                    color: Color(0xFF45A120),
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text(
                                  "6",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Image.asset(
                  "assets/icons/icon_no_noti.png",
                  width: 1.sw,
                  height: 1.sh * 1 / 2,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
