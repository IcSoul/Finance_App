abstract class Date {
  static Map<int, _Day> _weekdays = {
    1 : _Day("Monday", "Mon"),
    2 : _Day("Tuesday", "Tue"),
    3 : _Day("Wednesday", "Wed"),
    4 : _Day("Thursday", "Thu"),
    5 : _Day("Friday", "Fri"),
    6 : _Day("Saturday", "Sat"),
    7 : _Day("Sunday", "Sun")
  };

  static String getDayName(int pos){ return _weekdays[pos].day; }
  static String getDayAbbreviation(int pos){ return _weekdays[pos].abbreviation; }

  static DateTime getCurrentDate(int offset) {
    DateTime now = new DateTime.now();
    return new DateTime(now.year, now.month, now.day - offset);
  }

  static bool isSameDate(DateTime one, DateTime two){
    return one.year == two.year && one.month == two.month && one.day == two.day;
  }
}

class _Day {
  String _day;
  String _abbreviation;

  _Day(String name, String abbreviation){
    this._day = name;
    this._abbreviation = abbreviation;
  }

  String get day { return _day; }
  String get abbreviation { return _abbreviation; }
}