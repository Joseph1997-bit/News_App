import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const THEME_STATUS = "THEMESTATUS";
//SharedPreferences kullanarak asagidaki method uygulamanin rengi kayit etmek icin kullanilir
  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }
//SharedPreferences kullanarak asagidaki method uygulamanin rengi Storage'dan almak/cekmek icin kullanilir
  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //bu sekilde bool veya herhangi tur ve sakladigimzi degeri storge'dan alip kullanabiliriz
    return prefs.getBool(
      THEME_STATUS,
    ) ??
        false;
  }
}