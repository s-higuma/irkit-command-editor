import 'package:flutter/material.dart';
import 'package:irkit_command_editor/common/irkit_command.dart';
import 'package:irkit_command_editor/common/irkit_sheet.dart';
import 'package:quiver/iterables.dart';

class Editor extends StatefulWidget {
  final String title;
  final IRKitCommand command;

  Editor({Key key, this.title, this.command}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final icons = [
    Icon(Icons.title),
    Icon(Icons.comment),
    Icon(Icons.signal_wifi_4_bar)
  ];
  final labelTexts = ['コマンド名', 'ウェイクワード', '信号'];
  final helperTexts = ['コマンドの名前を入力', 'カンマ(,)区切りで入力', '取得ボタンを押して取得、もしくは直接入力'];
  IRKitSheet _sheet;
  IRKitCommand _command;

  @override
  void initState() {
    super.initState();
    _command = widget.command;
    _load();
  }

  Future<void> _load() async {
    if (_command.id == 0) return;
    final sheet = await IRKitSheet.getInstance();
    final command = await sheet.getCommand(_command.id);
    setState(() {
      _sheet = sheet;
      _command = command;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop("");
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_command.name),
        ),
        body: RefreshIndicator(
          onRefresh: _load,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                for (var i in range(labelTexts.length))
                  Row(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          icon: icons[i],
                          helperText: helperTexts[i],
                          labelText: labelTexts[i],
                        ),
                        initialValue: _command.name,
                        onSaved: (text) {
                          _command.name = text;
                          _sheet.addCommand(_command);
                        },
                      ),
                    ],
                  ),
                Row(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _command.wakeWords.join(','),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _command.message,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
