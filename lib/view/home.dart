import 'package:flutter/material.dart';
import 'package:irkit_command_editor/common/irkit_command.dart';
import 'package:irkit_command_editor/common/irkit_sheet.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  IRKitSheet _sheet;
  List<IRKitCommand> _commands;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sheet = await IRKitSheet.getInstance();
    final commands = await _sheet.getCommands();
    setState(() {
      _sheet = sheet;
      _commands = commands;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext c, int index) {
            final command = _commands[index];
            return ListTile(
              title: Text(command.name),
            );
          },
        ));
  }
}
