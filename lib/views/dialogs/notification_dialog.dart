import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationDialog extends StatelessWidget {
  final IconData? icon;
  final String title, message, assetImageLink;

  const NotificationDialog(
      {Key? key,
      this.icon,
      required this.title,
      required this.message,
      this.assetImageLink = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actionsAlignment: MainAxisAlignment.center,
      surfaceTintColor: Colors.transparent,
      title: Center(
          child: Text(
        title,
        textAlign: TextAlign.center,
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.h,
          ),
          Visibility(
              visible: assetImageLink != "",
              child: Image.asset(assetImageLink)),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
      actions: [
        FilledButton(
            onPressed: () => Navigator.pop(context), child: const Text("OK"))
      ],
    );
  }
}

const noInternetDialog = NotificationDialog(
    assetImageLink: "assets/images/robot_logout.png",
    title: "Không có kết nối",
    message:
        "Bạn đang không có kết nối internet. Vui lòng bật kết nối wifi hay 3G/4G, hoặc kiểm tra đường truyền.");
