import 'package:flutter/services.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:irkit_command_editor/common/config.dart';
import 'package:irkit_command_editor/common/irkit_command.dart';

class IRKitSheet {
  SpreadsheetsResourceApi _spreadSheetApi;
  Config _config;
  String _RANGE = 'irkit!A2:G';

  IRKitSheet();

  static Future<IRKitSheet> getInstance() async {
    final instance = IRKitSheet();
    final credentials = ServiceAccountCredentials.fromJson(
        await rootBundle.loadString('assets/credentials.json'));
    final scopes = const [SheetsApi.SpreadsheetsScope];
    instance._config = await Config.getInstance();
    instance._spreadSheetApi =
        SheetsApi(await clientViaServiceAccount(credentials, scopes))
            .spreadsheets;
    return instance;
  }

  Future<List<IRKitCommand>> getAllCommands() async {
    return getCommandsFromValueRange(await this.getValueRange(this._RANGE));
  }

  List<IRKitCommand> getCommandsFromValueRange(ValueRange valueRange) {
    return valueRange.values
        .map((r) => IRKitCommand(int.tryParse(r[0]), r[1], r[2],
            r.skip(3).map((x) => x.toString()).toList()))
        .toList();
  }

  Future<IRKitCommand> getCommand(int id) async {
    final commands = await this.getAllCommands();
    return commands.firstWhere((x) => x.id == id);
  }

  Future<IRKitCommand> addCommand(IRKitCommand command) async {
    final commands = await this.getAllCommands();
    final id = commands.last.id + 1;
    final column = command.wakeWords.length + 3;
    final range = 'irkit!A$id:$column';
    final valueRange = await getNewValueRange(range, [command.toList()]);
    final res = await _spreadSheetApi.values
        .update(valueRange, _config.sheetProjectId, range);
    return getCommandsFromValueRange(res.updatedData).first;
  }

  Future<ValueRange> getNewValueRange(
      String range, List<List<Object>> values) async {
    var valueRange = await getValueRange(range);
    valueRange.values = values;
    return valueRange;
  }

  Future<ValueRange> getValueRange(String range) async {
    return await _spreadSheetApi.values.get(_config.sheetProjectId, range);
  }
}
