import 'package:test/expect.dart';

export 'dart:async';

export 'package:test/test.dart';

Never show(Object t1, [Object? t2, Object? t3, Object? t4]) {
  fail([t1, t2, t3, t4].nonNulls.join('\n'));
}
