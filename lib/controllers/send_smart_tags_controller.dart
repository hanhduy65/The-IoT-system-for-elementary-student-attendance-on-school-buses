import 'package:momentum/momentum.dart';

import '../events/events.dart';
import '../models/send_smart_tags_response_model.dart';
import '../services/auth_service.dart';

class SendSmartTagsResponseController
    extends MomentumController<SendSmartTagsResponse> {
  @override
  SendSmartTagsResponse init() {
    return SendSmartTagsResponse(this, isSuccessful: true, responseMessage: '');
  }

  void setErrorMessage(String? value) {
    model.update(responseMessage: value);
  }

  Future<void> doSendSmartTags(int busId, List<String?> smartTagId) async {
    final authService = service<AuthServices>();
    final profile = await authService.sendSmartTags(busId, smartTagId);
    sendEvent(SendSmartTagsEvent(
        action: profile.isSuccessful, message: profile.responseMessage));
  }
}
