import 'package:momentum/momentum.dart';

import '../events/events.dart';
import '../models/register_smart_tag_response_model.dart';
import '../services/auth_service.dart';

class RegisterSmartTagResponseController
    extends MomentumController<RegisterSmartTagResponse> {
  @override
  RegisterSmartTagResponse init() {
    return RegisterSmartTagResponse(this,
        isSuccessful: true, responseMessage: '');
  }

  void setErrorMessage(String? value) {
    model.update(responseMessage: value);
  }

  Future<void> doSendRegisterSmartTag(
      String smartTagId, String studentId) async {
    final authService = service<AuthServices>();
    final profile =
        await authService.sendRegisterSmartTagStudent(smartTagId, studentId);
    sendEvent(RegisterSmartTagEvent(
        action: profile.isSuccessful, message: profile.responseMessage));
  }
}
