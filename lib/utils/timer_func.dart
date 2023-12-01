import "dart:async";

import "package:flutter_riverpod/flutter_riverpod.dart";

void setTimerFunc(int time, Function func, WidgetRef ref) {
  Timer.periodic(Duration(seconds: time), (timer) {
    func(ref);
  });
}

void setTimerChangeHP(
    int time, Function func, WidgetRef ref, bool changeHPFlag) {
  Timer.periodic(Duration(seconds: time), (timer) {
    func(ref, changeHPFlag);
  });
}
