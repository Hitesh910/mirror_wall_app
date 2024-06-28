import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper
{
  Future<void> setLink(List<String> link)
  async {
    SharedPreferences sha = await  SharedPreferences.getInstance();
    sha.setStringList('link', link);
    print(link);
  }

  getLink()
  async {
    SharedPreferences sha = await SharedPreferences.getInstance();
    List<String>? link = sha.getStringList('link');
    print(link);
    return link;
  }
}