import "dart:async";

import "package:flutter_riverpod/flutter_riverpod.dart";

void setTimerFunc(int time, Function func, WidgetRef ref) {
  Timer.periodic(Duration(seconds: time), (timer) {
    func(ref);
  });
}
