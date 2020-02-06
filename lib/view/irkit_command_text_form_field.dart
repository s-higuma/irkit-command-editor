import 'package:flutter/material.dart';

class IRKitCommandTextFormField extends StatefulWidget {
  final Key key;
  final String field;
  final String initialValue;
  final TextEditingController controller;
  final Function(String) onSaved;

  IRKitCommandTextFormField(
      {this.key, this.field, this.initialValue, this.controller, this.onSaved})
      : super(key: key);

  @override
  _IRKitCommandTextFormFieldState createState() =>
      _IRKitCommandTextFormFieldState();
}

class _IRKitCommandTextFormFieldState extends State<IRKitCommandTextFormField> {
  final Map<String, Icon> _icons = {
    'name': Icon(Icons.title),
    'message': Icon(Icons.signal_wifi_4_bar),
    'wakeWords': Icon(Icons.comment)
  };
  final Map<String, String> _labelTexts = {
    'name': 'コマンド名',
    'message': '信号',
    'wakeWords': 'ウェイクワード'
  };
  final Map<String, String> _helperTexts = {
    'name': 'コマンドの名前を入力',
    'message': '取得ボタンを押して取得、もしくは直接入力',
    'wakeWords': 'カンマ(,)区切りで入力'
  };

  @override
  Widget build(BuildContext context) {
    final field = widget.field;
    return TextFormField(
      key: widget.key,
      decoration: InputDecoration(
        icon: _icons[field],
        helperText: _helperTexts[field],
        labelText: _labelTexts[field],
      ),
      initialValue: widget.initialValue,
      controller: widget.controller,
      onSaved: widget.onSaved,
    );
  }
}
