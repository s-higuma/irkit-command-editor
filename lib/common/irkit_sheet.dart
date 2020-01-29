import 'dart:io';

import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:irkit_command_editor/common/config.dart';

class IRKitSheet {
  Config _config;
  Spreadsheet _sheets;

  IRKitSheet();

  static Future<IRKitSheet> getInstance() async {
    final instance = IRKitSheet();
    final credentials = ServiceAccountCredentials.fromJson(
        await File("../../credentials.json").readAsString());
    final scopes = const [SheetsApi.SpreadsheetsReadonlyScope];
    final config = await Config.getInstance();
    instance._sheets = await SheetsApi(
      await clientViaServiceAccount(credentials, scopes)).spreadsheets.get(config.sheetProjectId);
    instance._config = config; 
    return instance;
  }

  Future<List<List<String>>> getRegisteredData() async {

  }

}
