import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String dateFormat = "dd/MM/yyyy";
const String dateTimeFormat = "dd/MM/yyyy HH:mm:ss";
const String dateTimeTZFormat = "yyyy-MM-dd'T'HH:mm:ssZZ";

const secureStorage = FlutterSecureStorage();

const String serverURL =
    "https://us-central1-attendanceschoolbus.cloudfunctions.net";

const String timeFormat = "HH:mm:ss";

Map<String, String> loginHeaders = {
  "Content-Type": "multipart/form-data",
};

String get greetingLine {
  final hour = TimeOfDay.now().hour;
  if (hour <= 12) {
    return "Chào buổi sáng!";
  } else if (hour <= 17) {
    return "Xin chào!";
  }
  return "Chào buổi tối!";
}

const gradient1 = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment(0.8, 1),
  colors: <Color>[
    Color(0xff069efc),
    Color(0xff14f4c9),
  ], //
  tileMode: TileMode.mirror,
);

const gradient2 = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment(0.8, 1),
  colors: <Color>[
    Color(0xffff9100),
    Color(0xffff6B55),
    Color(0xfffff04A),
  ], //
  tileMode: TileMode.mirror,
);

const gradient3 = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: <Color>[
    Color(0xff1CB5A3),
    Color(0xff22B9A3),
    Color(0xff35C5A5),
    Color(0xff53DAA7),
    Color(0xff7AF4AB),
  ],
  tileMode: TileMode.mirror,
);

const gradient4 = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: <Color>[
    Color(0xff07A9F0),
    Color(0xff93DCFC),
  ],
  tileMode: TileMode.mirror,
);

const gradient5 = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: <Color>[
    Color(0xff339EFF),
    Color(0xff1A71FC),
  ],
  tileMode: TileMode.mirror,
);

const gradient6 = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: <Color>[
    Color(0xff9F4E5D),
    Color(0xff99FFAA),
  ],
  tileMode: TileMode.mirror,
);

const gradient7 = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: <Color>[
    Color(0xffff7ac9),
    Color(0xffd199ff),
  ],
  tileMode: TileMode.mirror,
);

extension ScreenUtils on BuildContext {
  Size get deviceSize {
    return MediaQuery.of(this).size;
  }

  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }

  TextStyle? get listTileSubtitleStyle {
    return Theme.of(this)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Theme.of(this).textTheme.bodySmall?.color);
  }
  //
  // DefaultChatTheme get chatTheme {
  //   return DefaultChatTheme(
  //       primaryColor: Theme.of(this).primaryColor,
  //       secondaryColor: Theme.of(this).colorScheme.secondaryContainer,
  //       inputTextColor: Colors.black,
  //       sendButtonIcon: const Icon(Icons.send_rounded),
  //       messageInsetsHorizontal: 15.w,
  //       messageInsetsVertical: 10.h,
  //       messageBorderRadius: 10.r,
  //       receivedMessageBodyTextStyle: Theme.of(this).textTheme.bodyMedium!,
  //       sentMessageBodyTextStyle: Theme.of(this)
  //           .textTheme
  //           .bodyMedium!
  //           .copyWith(color: Theme.of(this).scaffoldBackgroundColor),
  //       inputTextDecoration: BoxedInputDecoration(
  //           displayPrefixIcon: const Icon(Icons.chat_bubble_outline_rounded),
  //           filledColor: Theme.of(this).colorScheme.secondaryContainer),
  //       inputBackgroundColor: Theme.of(this).colorScheme.primaryContainer,
  //       backgroundColor: Theme.of(this).scaffoldBackgroundColor);
  // }
}
