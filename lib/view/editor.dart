import 'package:flutter/material.dart';
import 'package:irkit_command_editor/common/irkit_command.dart';
import 'package:irkit_command_editor/common/irkit_sheet.dart';
import 'package:irkit_command_editor/view/irkit_command_text_form_field_generator.dart';

class Editor extends StatefulWidget {
  final IRKitCommand command;

  Editor({Key key, this.command}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  IRKitSheet _sheet;
  IRKitCommand _command;

  @override
  void initState() {
    super.initState();
    _command = widget.command;
    _load();
  }

  Future<void> _load() async {
    final sheet = await IRKitSheet.getInstance();
    final command =
        (_command.id > 0) ? await sheet.getCommand(_command.id) : _command;
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
                IRKitCommandTextFormFieldGenerator(_command).generate('name',
                    (text) async {
                  _command.name = text;
                  _command = await _sheet.addCommand(_command);
                }),
                IRKitCommandTextFormFieldGenerator(_command).generate('message',
                    (text) async {
                  _command.message = text;
                  _command = await _sheet.addCommand(_command);
                }),
                IRKitCommandTextFormFieldGenerator(_command)
                    .generate('wakeWords', (text) async {
                  _command.wakeWords =
                      text.split(',').map((x) => x.trim()).toList();
                  _command = await _sheet.addCommand(_command);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
