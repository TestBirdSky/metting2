class DateTools {
  static String getHomeMessageTime(int millSecond) {
    final now = DateTime.now();
    final dateC = DateTime.fromMillisecondsSinceEpoch(millSecond);
    final year = now.year - dateC.year;
    if (year > 0) {
      return "很早以前";
    } else if (year == 0) {
      final mon = now.month - dateC.month;
      if (mon > 5) {
        return "半年前";
      } else if (mon == 0) {
        final day = now.day - dateC.day;
        if (day == 0) {
          return "${_timeFormat(dateC.hour)}:${_timeFormat(dateC.minute)}";
        } else {
          if (day == 1) {
            return "昨天";
          }
          return "$day天前";
        }
      } else {
        return "$mon个月前";
      }
    }
    return "$dateC";
  }
}

//00
String _timeFormat(int time) {
  if (time < 10) {
    return "0${time}";
  }
  return "$time";
}
