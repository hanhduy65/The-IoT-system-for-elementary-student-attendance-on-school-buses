import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/models/student_model.dart';

import '../../../controllers/login_controller.dart';
import '../../../controllers/student_register_RFID_controller.dart';
import '../../../events/events.dart';
import '../../../models/student_register_RFID_model.dart';
import '../../../models/user_model.dart';
import '../../widgets/card_student_register.dart';

class RegisterStudentByRFID extends StatefulWidget {
  final User? user;
  final int? busId;

  const RegisterStudentByRFID({super.key, this.busId, this.user});

  @override
  State<RegisterStudentByRFID> createState() => _RegisterStudentByRFIDState();
}

class _RegisterStudentByRFIDState extends MomentumState<RegisterStudentByRFID> {
  TextEditingController idDeviceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
        controllers: const [StudentRegisterRFIDListController],
        builder: (context, state) {
          final listStudents = state<StudentRegisterRFIDListModel>();
          if (!listStudents.isFetched) {
            listStudents.controller.getStudentRegisterRFIDList(widget.busId!);
            listStudents.update(isFetched: true);
          }
          print("list students${listStudents.studentList}");
          return RefreshIndicator(
              onRefresh: () async {
                listStudents.controller
                    .getStudentRegisterRFIDList(widget.busId!);
              },
              child: listStudents.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : listStudents.studentList.isEmpty
                      ? Center(
                          child: Text(
                              "Danh sách học sinh cần đăng kí thẻ RFID trống"))
                      : Container(
                          height: 1.sh,
                          child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: false,
                              itemCount: listStudents.studentList.length,
                              itemBuilder: (context, index) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: InkWell(
                                      child: Card(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CardStudentRegister(
                                              name: listStudents
                                                  .studentList[index]
                                                  .studentName),
                                        ),
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Yêu cầu đăng kí thẻ RFID'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'Học sinh:  ',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: listStudents
                                                                  .studentList[
                                                                      index]
                                                                  .studentName ??
                                                              " ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                20.sp, // In đậm
                                                            color: Color(
                                                                0xFF58952D),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    children: [
                                                      Text("ID thiết bị: "),
                                                      SizedBox(width: 5.w),
                                                      Expanded(
                                                        child: TextField(
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          controller:
                                                              idDeviceController,
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                "Nhập vào id thiết bị...",
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 2,
                                                                    color: Color(
                                                                        0xFF58952D))),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Hủy'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Momentum.controller<
                                                                LoginController>(
                                                            context)
                                                        .doSendRequestRegisterStudent(
                                                            int.parse(
                                                                idDeviceController
                                                                    .text),
                                                            listStudents
                                                                .studentList[
                                                                    index]
                                                                .studentId!)
                                                        .then((_) {
                                                      Future.delayed(
                                                          Duration(seconds: 1),
                                                          () {
                                                        setState(() {
                                                          Momentum.controller<
                                                                      StudentRegisterRFIDListController>(
                                                                  context)
                                                              .getStudentRegisterRFIDList(
                                                                  widget
                                                                      .busId!);
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    });
                                                  },
                                                  child: const Text('Gửi'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  )),
                        ));
        });
  }

  void initMomentumState() {
    // TODO: implement initMomentumState
    super.initMomentumState();
    final loginController = Momentum.controller<LoginController>(context);
    loginController.listen<RegisterEvent>(
      state: this,
      invoke: (event) {
        switch (event.action) {
          case true:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gửi yêu cầu đăng kí thẻ thành công'),
                backgroundColor: Colors.green, // Thay đổi màu sắc ở đây
              ),
            );
            break;
          case false:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gửi yêu cầu đăng kí thẻ thất bại'),
                backgroundColor: Colors.red, // Thay đổi màu sắc ở đây
              ),
            );
            break;
          case null:
            print(event.message);
            break;
          default:
        }
      },
    );
  }
}
/*
Widget _buildPopupDialog(BuildContext context, StudentModel stu,
    TextEditingController idDeviceController, int? busId) {
  return AlertDialog(
    title: const Text('Yêu cầu đăng kí thẻ RFID'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: 'Học sinh:  ',
            style: const TextStyle(
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: stu.studentName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp, // In đậm
                  color: Color(0xFF58952D), // Màu khác
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Text("ID thiết bị: "),
            SizedBox(width: 5.w),
            Expanded(
              child: TextField(
                textInputAction: TextInputAction.next,
                controller: idDeviceController,
                decoration: const InputDecoration(
                  hintText: "Nhập vào id thiết bị...",
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFF58952D))),
                ),
              ),
            ),
          ],
        )
      ],
    ),
    actions: <Widget>[
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Hủy'),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          Momentum.controller<LoginController>(context)
              .doSendRequestRegisterStudent(
                  int.parse(idDeviceController.text), stu.studentId!);
          Momentum.controller<StudentRegisterRFIDListController>(context)
              .getStudentRegisterRFIDList(busId!);
        },
        child: const Text('Gửi'),
      ),
    ],
  );
}

 */
