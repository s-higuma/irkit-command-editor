import 'package:flutter/material.dart';
import 'package:irkit_command_editor/common/irkit_command.dart';
import 'package:irkit_command_editor/common/irkit_sheet.dart';
import 'package:irkit_command_editor/view/editor.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<IRKitCommand> _commands = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sheet = await IRKitSheet.getInstance();
    final commands = await sheet.getAllCommands();
    setState(() {
      _commands = commands;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          itemBuilder: (BuildContext c, int index) {
            if (index >= _commands.length) return null;
            final command = _commands[index];
            return ListTile(
              title: Text(command.name),
              onTap: () async {
                final result = await navigateEditor(context, command);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final command = IRKitCommand(0, '新しいコマンド', '', []);
          final result = await navigateEditor(context, command);
        },
        tooltip: 'コマンドの追加',
      ),
    );
  }

  Future<String> navigateEditor(
      BuildContext context, IRKitCommand command) async {
    return await Navigator.of(context).push(MaterialPageRoute<String>(
        builder: (context) => Editor(
              title: widget.title,
              command: command,
            )));
  }
}
