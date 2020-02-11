import 'package:http/http.dart' as http;
import 'package:irkit_command_editor/common/config.dart';

class IRKitApiManager {
  IRKitApiManager();

  Future<String> getMessage() async {
    final config = await Config.getInstance();
    var url =
        "https://api.getirkit.com/1/messages?clientkey=${config.irkitClientKey}";
    http.Response res;
    for (var i = 0; i < 2; i++) {
      res = (i == 0) ? await http.get('$url&clear=1') : await http.get(url);
      if (res.statusCode != 200)
        throw Exception('通信に失敗しました。時間を置いてから再度お試しください。');
      if (res.body != '') break;
      if (i == 1) throw Exception('一定時間入力がありませんでした。再度お試しください。');
    }
    return res.body.splitMapJoin(RegExp(r'{.*}'),
        onMatch: (m) => '${m.group(0)}', onNonMatch: (n) => '');
  }
}
