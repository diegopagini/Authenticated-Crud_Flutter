import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: '.env'); // To use ennvironment variables
  }

  static String apiUrl = dotenv.env['API_URL'] ?? 'There is no api url';
}
