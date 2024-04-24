import 'package:momentum/momentum.dart';

import '../controllers/save_attendance_history_response_controller.dart';

class SaveAttendanceHistoryResponse
    extends MomentumModel<SaveAttendanceHistoryResponseController> {
  final bool? isSuccessful;
  final String? responseMessage;
  const SaveAttendanceHistoryResponse(
      SaveAttendanceHistoryResponseController controller,
      {this.isSuccessful,
      this.responseMessage})
      : super(controller);

  @override
  SaveAttendanceHistoryResponse fromJson(Map<String, dynamic>? json) {
    return SaveAttendanceHistoryResponse(
      controller,
      isSuccessful: json?["success"],
      responseMessage: json?["message"],
    );
  }

  @override
  void update({bool? isSuccessful, String? responseMessage}) {
    SaveAttendanceHistoryResponse(controller,
            isSuccessful: isSuccessful ?? this.isSuccessful,
            responseMessage: responseMessage ?? this.responseMessage)
        .updateMomentum();
  }
}
