import 'package:momentum/momentum.dart';

import '../controllers/register_smart_tag_response_controller.dart';

class RegisterSmartTagResponse
    extends MomentumModel<RegisterSmartTagResponseController> {
  final bool? isSuccessful;
  final String? responseMessage;
  const RegisterSmartTagResponse(RegisterSmartTagResponseController controller,
      {this.isSuccessful, this.responseMessage})
      : super(controller);

  @override
  RegisterSmartTagResponse fromJson(Map<String, dynamic>? json) {
    return RegisterSmartTagResponse(
      controller,
      isSuccessful: json?["success"],
      responseMessage: json?["message"],
    );
  }

  @override
  void update({bool? isSuccessful, String? responseMessage}) {
    RegisterSmartTagResponse(controller,
            isSuccessful: isSuccessful ?? this.isSuccessful,
            responseMessage: responseMessage ?? this.responseMessage)
        .updateMomentum();
  }
}
