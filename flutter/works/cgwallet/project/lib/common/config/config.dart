import 'package:flutter/services.dart';

part 'app.dart';
part 'shard.dart';
part 'urls.dart';
part 'key.dart';
part 'channel.dart';

class MyConfig {
  static final app = _App();
  static final shard = _Shard();
  static final urls = _Urls();
  static final key = _Key();
  static final channel = _Channel();

}
