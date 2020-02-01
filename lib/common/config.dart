import 'dart:convert';

import 'package:flutter/services.dart';

class Config {
  static Config _instance;
  final String sheetProjectId;

  Config(this.sheetProjectId);

  static Future<Config> getInstance() async {
    final config =
        await json.decode(await rootBundle.loadString('assets/config.json'));
    if (_instance == null) _instance = Config(config.sheetProjectId);
    return _instance;
  }
}
