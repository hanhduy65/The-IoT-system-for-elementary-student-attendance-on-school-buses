import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import 'choose_role.dart';

class InfoAccount extends StatelessWidget {
  final User? user;
  const InfoAccount({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final circleRadius = 136.0;
    final TextStyle detailTextStyle =
        TextStyle(fontSize: 14.sp, color: const Color(0xff51697E));
    return Scaffold(
      body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(children: <Widget>[
            Padding(
                padding: EdgeInsets.all(30.r),
                child: Column(children: [
                  Stack(alignment: Alignment.topCenter, children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                          top: circleRadius / 2.0,
                        ),
                        child: Card(
                            margin: EdgeInsets.zero,
                            color: Color(0xFFFAD364),
                            child: Padding(
                                padding: EdgeInsetsDirectional.symmetric(
                                    vertical: 15.h),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(height: circleRadius / 2),
                                      Text(
                                        (user?.fullName ?? "Luu Minh Huong")
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                          (user?.roleId == 1
                                                  ? " parent"
                                                  : user?.roleId == 3
                                                      ? "teacher"
                                                      : "manager")
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Color(0xff51697E),
                                              fontSize: 12.0)),
                                      SizedBox(height: 32.h),
                                      Divider(
                                          endIndent: 40,
                                          indent: 40,
                                          thickness: 3.h,
                                          color: Colors.white),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 25.h, horizontal: 30.w),
                                          // color: const Color(0xffF5F7FD),
                                          child: Table(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceBetween,
                                              columnWidths: {
                                                0: const FlexColumnWidth(),
                                                1: FixedColumnWidth(26.w),
                                                2: const FlexColumnWidth(2)
                                              },
                                              children: [
                                                TableRow(children: [
                                                  Text("SĐT:",
                                                      style: detailTextStyle),
                                                  const SizedBox.shrink(),
                                                  Text(
                                                      user?.phone.toString() ??
                                                          "",
                                                      style: detailTextStyle,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis)
                                                ]),
                                                TableRow(children: [
                                                  SizedBox(height: 10.h),
                                                  const SizedBox.shrink(),
                                                  const SizedBox.shrink()
                                                ]),
                                                TableRow(children: [
                                                  Text("Email:",
                                                      style: detailTextStyle),
                                                  const SizedBox.shrink(),
                                                  Text(user?.userName ?? "",
                                                      style: detailTextStyle,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis)
                                                ]),
                                                TableRow(children: [
                                                  SizedBox(height: 10.h),
                                                  const SizedBox.shrink(),
                                                  const SizedBox.shrink()
                                                ]),
                                                TableRow(children: [
                                                  Text(
                                                      user?.roleId == 3
                                                          ? "Supervisor:"
                                                          : "Children: ",
                                                      style: detailTextStyle),
                                                  const SizedBox.shrink(),
                                                  Text("bus 01",
                                                      style: detailTextStyle,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis)
                                                ]),
                                                TableRow(children: [
                                                  SizedBox(height: 10.h),
                                                  const SizedBox.shrink(),
                                                ]),
                                                TableRow(children: [
                                                  Text("User name:",
                                                      style: detailTextStyle),
                                                  const SizedBox.shrink(),
                                                  Text(user?.userName ?? " ",
                                                      style: detailTextStyle,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis)
                                                ])
                                              ]))
                                    ])))),

                    ///Image Avatar
                    Container(
                        width: circleRadius,
                        height: circleRadius,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
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
                                        'assets/image_avt/avt.jpg')))))
                  ]),
                  SizedBox(height: 50.h),
                  TextButton.icon(
                      onPressed: () async {
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        sp.clear();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => ChoosingRole()));
                      },
                      icon: Icon(Icons.power_settings_new,
                          color: Theme.of(context).primaryColor),
                      label: Text("log out".toUpperCase(),
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)))
                ]))
          ])),
    );
  }
}
