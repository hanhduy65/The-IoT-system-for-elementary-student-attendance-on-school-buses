import 'package:busmate/views/screens/choose_role_remake.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: 1.sw,
          height: 1.sh,
          child: Image.asset("assets/images/background_welcome_page.jpg",
              fit: BoxFit.fitWidth),
        ),
        Positioned(
            bottom: 40,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "BusMate",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFA82C),
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 7.0,
                              color: Colors.black,
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Card(
                      color: Colors.white,
                      child: Container(
                        width: 1.sw * 0.9,
                        height: 1.sh * 1 / 4,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Starting with a smart application for parents, teachers and schools to effectively manage and track student's attendance on the bus."),
                              SizedBox(
                                width: 1.sw,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChooseRoleRemake(),
                                          ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Color(0xFF36A945),
                                      elevation: 6,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 65.0, vertical: 15),
                                      child: Text("Login",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Positioned(
          top: 20,
          right: 20,
          child: Image.asset("assets/images/logo_fpt_uni.png", height: 45.h),
        ),
      ],
    ));
  }
}
