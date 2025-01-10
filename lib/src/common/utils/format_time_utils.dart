import 'package:intl/intl.dart';

class FormatTimeUtils {
  FormatTimeUtils._();

  static String timeAgo(DateTime dateTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inDays >= 7) {
      int weeks = (difference.inDays / 7).floor();
      return '$weeks tuần trước';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  static String getHourAndMinute(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    if (isoDate == '') dateTime = DateTime.now();
    return DateFormat('HH:mm').format(dateTime.toLocal());
  }
  
  static String getDayMonthYear(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    if (isoDate == '') dateTime = DateTime.now();
    return DateFormat('dd/MM/yyyy').format(dateTime.toLocal());
  }
}
