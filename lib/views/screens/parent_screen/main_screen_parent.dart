import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreenParent extends StatefulWidget {
  const MainScreenParent({super.key});

  @override
  State<MainScreenParent> createState() => _MainScreenParentState();
}

class _MainScreenParentState extends State<MainScreenParent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, parent",
                style: TextStyle(fontSize: 16.sp, color: Colors.black87),
              ),
              Text(
                "Le Duc Minh",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Color(0xFFECAB33),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThuWKm5rlVyc9oN3WSsKcGPwRehbxGOAxqTY2mgaFsCQ&s'),
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
              child: Card(
                elevation: 0,
                color: Color(0xFF509F31),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: AssetImage("assets/image_avt/images4.jpg"),
                  ),
                  title: Text(
                    "Le Duc Tri",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "4A3 - HS43279",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Màu nền trùng với màu cha
                      borderRadius:
                          BorderRadius.circular(10), // Đường viền cong
                      border: Border.all(
                        color: Color(0xFFECAB33), // Màu viền
                        width: 1, // Độ rộng của viền
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Xử lý sự kiện khi nút được nhấn
                      },
                      child: Text("Safe on bus",
                          style: TextStyle(
                              color: Color(0xFFF3AD29),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Information today",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
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
                              "Plate No",
                              style: TextStyle(
                                color: Color(0xFFECAB33),
                                fontSize: 16.sp,
                              ),
                            ),
                            Text("bus x001",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold)),
                            Text("17B - 17026",
                                style: TextStyle(fontSize: 14.sp)),
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
                              "Driver",
                              style: TextStyle(
                                color: Color(0xFFDC7D32),
                                fontSize: 16.sp,
                              ),
                            ),
                            Text("Ngo Van Long",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold)),
                            Text("0986825596",
                                style: TextStyle(fontSize: 14.sp)),
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
                            Stack(
                              children: [
                                Image.asset(
                                  "assets/icons/teacher.png",
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
                                    color: Color(0xFF45A120),
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "Supervisor",
                              style: TextStyle(
                                color: Color(0xFF45A120),
                                fontSize: 16.sp,
                              ),
                            ),
                            Text("Le Minh Hien",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold)),
                            Text("0856898687",
                                style: TextStyle(fontSize: 14.sp)),
                          ],
                        ),
                      ),
                    ),
                  ),
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
    );
  }
}
