import 'package:momentum/momentum.dart';

import '../controllers/take_attendance_response_controller.dart';

class TakeAttendanceResponse
    extends MomentumModel<TakeAttendanceResponseController> {
  final bool? isSuccessful;
  final String? responseMessage;
  const TakeAttendanceResponse(TakeAttendanceResponseController controller,
      {this.isSuccessful, this.responseMessage})
      : super(controller);

  @override
  TakeAttendanceResponse fromJson(Map<String, dynamic>? json) {
    return TakeAttendanceResponse(
      controller,
      isSuccessful: json?["success"],
      responseMessage: json?["message"],
    );
  }

  @override
  void update({bool? isSuccessful, String? responseMessage}) {
    TakeAttendanceResponse(controller,
            isSuccessful: isSuccessful ?? this.isSuccessful,
            responseMessage: responseMessage ?? this.responseMessage)
        .updateMomentum();
  }
}
