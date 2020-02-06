import 'dart:convert';

import 'package:flutter/services.dart';

class Config {
  static Config _instance;
  final String sheetProjectId;
  final String irkitClientKey;

  Config(this.sheetProjectId, this.irkitClientKey);

  static Future<Config> getInstance() async {
    final config =
        await json.decode(await rootBundle.loadString('assets/config.json'));
    if (_instance == null)
      _instance = Config(config["sheetProjectId"], config["irkitClientKey"]);
    return _instance;
  }
}
