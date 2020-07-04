import 'package:http/http.dart' as http;
import 'package:homely_fresh_food/modals/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

String baseUrl = 'http://hff.nyxwolves.xyz/api/profile';

Future<Profile> getProfileData() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String basicAuth = sharedPreferences.getString("token");

  try {
    final response =
        await http.get('$baseUrl', headers: {'authorization': basicAuth});
    if (200 == response.statusCode) {
      return profileFromJson(response.body);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }

// print(response.body);
}
