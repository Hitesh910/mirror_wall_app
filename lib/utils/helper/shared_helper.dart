import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper
{
  Future<void> setLink(String link)
  async {
    SharedPreferences sha = await  SharedPreferences.getInstance();
    sha.setString('link', link);
    print(link);
  }

  getLink()
  async {
    SharedPreferences sha = await SharedPreferences.getInstance();
    String? link = sha.getString('link');
    print(link);
    return link;
  }
}