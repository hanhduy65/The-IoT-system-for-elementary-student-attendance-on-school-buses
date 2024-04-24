import 'package:momentum/momentum.dart';

import '../controllers/send_smart_tags_controller.dart';

class SendSmartTagsResponse
    extends MomentumModel<SendSmartTagsResponseController> {
  final bool? isSuccessful;
  final String? responseMessage;
  const SendSmartTagsResponse(SendSmartTagsResponseController controller,
      {this.isSuccessful, this.responseMessage})
      : super(controller);

  @override
  SendSmartTagsResponse fromJson(Map<String, dynamic>? json) {
    return SendSmartTagsResponse(
      controller,
      isSuccessful: json?["success"],
      responseMessage: json?["message"],
    );
  }

  @override
  void update({bool? isSuccessful, String? responseMessage}) {
    SendSmartTagsResponse(controller,
            isSuccessful: isSuccessful ?? this.isSuccessful,
            responseMessage: responseMessage ?? this.responseMessage)
        .updateMomentum();
  }
}
