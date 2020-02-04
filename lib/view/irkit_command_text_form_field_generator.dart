import 'package:flutter/material.dart';
import 'package:irkit_command_editor/common/irkit_command.dart';

class IRKitCommandTextFormFieldGenerator {
  final IRKitCommand command;
  final Map<String, Icon> icons = {
    'name': Icon(Icons.title),
    'message': Icon(Icons.signal_wifi_4_bar),
    'wakeWords': Icon(Icons.comment)
  };
  final Map<String, String> labelTexts = {
    'name': 'コマンド名',
    'message': '信号',
    'wakeWords': 'ウェイクワード'
  };
  final Map<String, String> helperTexts = {
    'name': 'コマンドの名前を入力',
    'message': '取得ボタンを押して取得、もしくは直接入力',
    'wakeWords': 'カンマ(,)区切りで入力'
  };

  IRKitCommandTextFormFieldGenerator(this.command);

  TextFormField generate(String field, Function(String) onChanged) {
    final cmd = command.toMap();
    return TextFormField(
      decoration: InputDecoration(
        icon: icons[field],
        helperText: helperTexts[field],
        labelText: labelTexts[field],
      ),
      initialValue: cmd[field],
      onFieldSubmitted: onChanged,
    );
  }
}
