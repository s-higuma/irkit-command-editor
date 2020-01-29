import 'dart:convert';
import 'dart:io';

class Config {
  static Config _instance;
  final String sheetProjectId;

  Config(this.sheetProjectId);

  static Future<Config> getInstance() async {
    final config = await json.decode(await File("../../config.json").readAsString());
    if (_instance == null) _instance = Config(config.sheetProjectId);
    return _instance;
  }
}
