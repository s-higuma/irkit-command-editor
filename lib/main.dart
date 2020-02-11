import 'package:flutter/material.dart';
import 'package:irkit_command_editor/view/home.dart';

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();
void main() => runApp(IRKitCommandEditor());

class IRKitCommandEditor extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'irkit_command_editor',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          buttonColor: Colors.blue,
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          )),
      home: Home(title: 'IRKit Command Editor'),
      navigatorObservers: <NavigatorObserver>[routeObserver],
    );
  }
}
