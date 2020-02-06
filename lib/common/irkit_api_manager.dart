import 'package:http/http.dart' as http;
import 'package:irkit_command_editor/common/config.dart';

class IRKitApiManager {
  IRKitApiManager();

  Future<String> getMessage() async {
    final config = await Config.getInstance();
    final client = _IRKitHttpClient(http.Client());
    var url =
        "https://api.getirkit.com/1/messages?clientkey=${config.irkitClientKey}";
    http.Response res;
    for (var i = 0; i < 6; i++) {
      res = (i == 0) ? await client.get('$url&clear=1') : await client.get(url);
      if (res.statusCode != 200)
        throw Exception('通信に失敗しました。時間を置いてから再度お試しください。');
      if (res.body != '') break;
      if (i == 5) throw Exception('一定時間入力がありませんでした。再度お試しください。');
    }
    return res.body.splitMapJoin(RegExp(r'{.*}'),
        onMatch: (m) => '${m.group(0)}', onNonMatch: (n) => '');
  }
}

class _IRKitHttpClient extends http.BaseClient {
  final http.Client _inner;

  _IRKitHttpClient(this._inner);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['X-Requested-With'] = 'curl';
    return _inner.send(request);
  }
}
