import 'package:flutter/services.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:irkit_command_editor/common/config.dart';
import 'package:irkit_command_editor/common/irkit_command.dart';

class IRKitSheet {
  SpreadsheetsResourceApi _spreadSheet;
  Config _config;

  IRKitSheet();

  static Future<IRKitSheet> getInstance() async {
    final instance = IRKitSheet();
    final credentials = ServiceAccountCredentials.fromJson(
        await rootBundle.loadString('assets/credentials.json'));
    final scopes = const [SheetsApi.SpreadsheetsReadonlyScope];
    instance._config = await Config.getInstance();
    instance._spreadSheet =
        SheetsApi(await clientViaServiceAccount(credentials, scopes))
            .spreadsheets;
    return instance;
  }

  Future<List<List<Object>>> getValues() async {
    final vr =
        await _spreadSheet.values.get(_config.sheetProjectId, "irkit!A2:G");
    return vr.values;
  }

  Future<List<IRKitCommand>> getCommands() async {
    final rows = await this.getValues();
    return rows
        .map((r) => IRKitCommand(r[0], r[1], r.skip(2).toList()))
        .toList();
  }
}
