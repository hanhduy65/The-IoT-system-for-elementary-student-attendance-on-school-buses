import 'package:intl/intl.dart';

import '../utils/global.dart';

extension FormatTime on DateTime {
  String get formatTime => DateFormat(timeFormat).format(this);
}

extension FormatDateTime on DateTime {
  String get formatDateTime => DateFormat(dateTimeFormat).format(this);
}

extension FormatDate on DateTime {
  String get formatDate => DateFormat(dateFormat).format(this);
}

extension FormatDateTimeTz on DateTime {
  String get formatDateTimeTz => DateFormat(dateTimeTZFormat).format(this);
}

extension TextTime on DateTime {
  String textTime() {
    if (this == "") {
      return "0 giây";
    }

    int diff = DateTime.now().millisecondsSinceEpoch - millisecondsSinceEpoch;

    if (diff > (24 * 60 * 60)) {
      return formatDate;
    }

    if (diff > (1 * 60 * 60)) {
      int hour = (diff / (60 * 60)) as int;
      return "$hour giờ";
    }

    if (diff > 60) {
      int minutes = (diff / 60) as int;
      return "$minutes phút";
    }

    return "$diff giây";
  }
}
