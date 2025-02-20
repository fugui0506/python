import 'dart:math';

class MyRandom {
  static final MyRandom _instance = MyRandom._privateConstructor();
  MyRandom._privateConstructor();
  static MyRandom get to => _instance;

  int getUuid() {
    // int timestamp = DateTime.now().millisecondsSinceEpoch;
    int randomValue = Random().nextInt(100000);

    // int uuuid = int.parse('$timestamp$randomValue');

    return randomValue;
  }
}