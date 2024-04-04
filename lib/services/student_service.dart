import 'dart:convert';

import 'package:momentum/momentum.dart';

import '../controllers/attendance_controller.dart';
import '../controllers/student_controller.dart';
import '../controllers/student_on_bus_list_controller.dart';
import '../models/attendance_history_model.dart';
import '../models/attendance_model.dart';
import '../models/student_model.dart';
import '../models/student_on_bus_list_model.dart';
import '../utils/global.dart';
import 'general_api_service.dart';

class StudentServices extends MomentumService {
  Future<List<StudentModel>> getAllStudent() async {
    print("GOI SERVICE STUDENT");
    String url = "$serverURL/getAllStudents";
    try {
      final response = await httpService.get(url);
      StudentModel student = StudentController().init();
      return (response as List).map((e) => student.fromJson(e)).toList();
    } on Exception catch (e) {
      print("Get list student error: $e");
      return [];
    }
  }

  Future<StudentOnBusListModel> getStudentOnBus(int busId) async {
    String url = "$serverURL/getStudentOnBus";
    // print(requestModel.toJson());
    try {
      final response = await httpService.post(url, body: {'busId': busId});
      StudentOnBusListModel attendance = StudentOnBusListController().init();
      return attendance.fromJson(response);
    } on Exception catch (e) {
      print("Get list student on bus error: $e");
      return StudentOnBusListModel(StudentOnBusListController(),
          studentList: []);
    }
  }

  Future<List<StudentModel>> getStudentRegisterRFID(int busId) async {
    print("service + getStudentRegisterRFID");
    String url = "$serverURL/getStudentsNoRFID?busId=$busId";
    try {
      final response = await httpService.get(url);
      StudentModel student = StudentController().init();
      return (response as List).map((e) => student.fromJson(e)).toList();
    } on Exception catch (e) {
      print("Get list student register RFID error: $e");
      return [];
    }
  }

  Future<List<StudentModel>> getStudentRegisterFingerprint(int busId) async {
    print("service + getStudentRegisterFingerprint");
    String url = "$serverURL/getStudentsNoFinger?busId=$busId";
    try {
      final response = await httpService.get(url);
      StudentModel student = StudentController().init();
      return (response as List).map((e) => student.fromJson(e)).toList();
    } on Exception catch (e) {
      print("Get list student register Fingerprint error: $e");
      return [];
    }
  }

  Future<StudentModel> searchStudentById(String studentId) async {
    String url = "$serverURL/getStudentById";
    print("Có vào đây");
    // print(requestModel.toJson());
    try {
      final response =
          await httpService.post(url, body: {'studentId': studentId});
      print(response);
      StudentModel customer = StudentController().init();
      print("aaaaaaa");
      return customer.fromJson(response);
    } on Exception catch (e, stackTrace) {
      print("search student error: $e");
      print("Stack trace: $stackTrace");
      return StudentModel(StudentController());
    }
  }

  Future<StudentModel> getStudentIdByParentId(String parentId) async {
    String url = "$serverURL/getStudentIdsByParent";
    print("Có vào đây");
    // print(requestModel.toJson());
    try {
      final response =
          await httpService.post(url, body: {'parentId': parentId});
      print(response);
      StudentModel customer = StudentController().init();
      return customer.fromJson(response);
    } on Exception catch (e, stackTrace) {
      print("search student error: $e");
      print("Stack trace: $stackTrace");
      return StudentModel(StudentController());
    }
  }

  Future<List<HistoryAttendanceModel>> getHistoryAttendanceById(
      String studentId) async {
    String url = "$serverURL/getAttendanceReportByStudentId";
    print("Có vào đây");
    var body = {'studentId': studentId};
    print(body);
    try {
      final response = await httpService.post(url, body: body);
      print("getAttendanceReportByStudentId: ${response}");
      return (response as List)
          .map((e) => HistoryAttendanceModel.fromJson(e))
          .toList();
    } on Exception catch (e, stackTrace) {
      print("get history attendance error: $e");
      print("Stack trace: $stackTrace");
      return [];
    }
  }
}
