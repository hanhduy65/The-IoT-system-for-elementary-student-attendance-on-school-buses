import 'package:flutter/material.dart';

import '../../models/student_model.dart';

class CardStudentRegister extends StatelessWidget {
  final StudentModel? stu;
  final int? index;
  const CardStudentRegister({super.key, this.stu, this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: CircleAvatar(
          radius: 30.0,
          backgroundImage: index == 0
              ? const AssetImage("assets/image_avt/images1.jpg")
              : index == 1
                  ? AssetImage("assets/image_avt/images2.jpg")
                  : index == 2
                      ? AssetImage("assets/image_avt/images3.jpg")
                      : index == 3
                          ? AssetImage("assets/image_avt/images4.jpg")
                          : AssetImage("assets/image_avt/images5.jpg"),
          backgroundColor: Colors.transparent,
        ),
      ),
      title: Text(
        stu?.studentName ?? "",
        style: const TextStyle(color: Colors.black),
      ),
      trailing: IntrinsicHeight(
        child: Text(
          stu?.studentId ?? " ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
