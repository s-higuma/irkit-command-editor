import 'package:flutter/services.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:irkit_command_editor/common/config.dart';
import 'package:irkit_command_editor/common/irkit_command.dart';

class IRKitSheet {
  Sheet _sheet;

  IRKitSheet();

  static Future<IRKitSheet> getInstance() async {
    final instance = IRKitSheet();
    final credentials = ServiceAccountCredentials.fromJson(
        await rootBundle.loadString('assets/credentials.json'));
    final scopes = const [SheetsApi.SpreadsheetsReadonlyScope];
    final config = await Config.getInstance();
    final spreadsheet =
        await SheetsApi(await clientViaServiceAccount(credentials, scopes))
            .spreadsheets
            .get(config.sheetProjectId);
    instance._sheet =
        spreadsheet.sheets.firstWhere((x) => x.properties.title == "irkit");
    return instance;
  }

  Future<List<IRKitCommand>> getCommands() async {
    final rows = _sheet.data.first.rowData;
    final commands = [];
    rows.getRange(1, rows.length).map((row) {
      final v =
          row.values.map((cell) => cell.effectiveValue.toString()).toList();
      commands.add(IRKitCommand(v[0], v[1], v.getRange(2, v.length)));
    });
    return commands;
  }
}
