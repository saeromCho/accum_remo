class Formatter {
  static String formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final isAM = hour < 12;

    return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${isAM ? '오전' : '오후'} ${hour % 12}:${minute.toString().padLeft(2, '0')}';
  }

  static String formatDateTimeFromString(String dateTimeString) {
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(dateTimeString);
    } catch (e) {
      // 문자열 파싱에 실패한 경우 예외 처리
      return "Invalid date"; // 또는 다른 적절한 처리
    }

    return formatDateTime(dateTime); // 위에서 정의한 formatDateTime 함수 사용
  }
}
