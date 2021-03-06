import 'package:flutter/material.dart';
import 'package:irkit_command_editor/common/irkit_api_manager.dart';
import 'package:irkit_command_editor/common/irkit_command.dart';
import 'package:irkit_command_editor/common/irkit_sheet.dart';
import 'package:irkit_command_editor/view/irkit_command_text_form_field.dart';

class Editor extends StatefulWidget {
  final IRKitCommand command;

  Editor({Key key, this.command}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  IRKitSheet _sheet;
  IRKitCommand _command;
  TextEditingController _messageInputController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _command = widget.command;
    _load();
    _messageInputController.text = _command.message;
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

  Future<void> _register() async {
    _formKey.currentState.save();
    final command = await _sheet.addCommand(_command);
    setState(() => _command = command);
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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  IRKitCommandTextFormField(
                      field: 'name',
                      initialValue: _command.name,
                      onSaved: (inputText) async {
                        _command.name = inputText;
                      }),
                  IRKitCommandTextFormField(
                      field: 'wakeWords',
                      initialValue: _command.wakeWords.join(','),
                      onSaved: (inputText) async {
                        _command.wakeWords =
                            inputText.split(',').map((x) => x.trim()).toList();
                      }),
                  IRKitCommandTextFormField(
                      field: 'message',
                      controller: _messageInputController,
                      onSaved: (inputText) async {
                        _command.message = inputText;
                      }),
                  FlatButton(
                    child: Text('IRKitから信号を取得'),
                    onPressed: () async {
                      String msg;
                      try {
                        _messageInputController.text =
                            '信号受信待機中...(リモコンをIRKitの方に向けて、登録したいボタンを押して下さい)';
                        msg = await IRKitApiManager().getMessage();
                      } on Exception catch (e) {
                        msg = e.toString().replaceFirst('Exception: ', '');
                      }
                      _messageInputController.text = msg;
                    },
                  ),
                  RaisedButton(
                    child: Text('登録'),
                    onPressed: _register,
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
