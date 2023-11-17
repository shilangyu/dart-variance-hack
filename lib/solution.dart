import 'package:variance/problem.dart';

typedef Contra<T> = void Function(T);
Contra<T> makeContra<T>() => (T _) {};

class Comms {
  final List<(Contra<Never>, Consumer<dynamic>)> handlers = [];

  void addSink<T>(Consumer<T> sink) {
    final key = makeContra<T>();
    handlers.add((key, sink));
  }

  void sendEvent<T>(T value) {
    final targets = handlers
        .whereType<(Contra<T>, Consumer<dynamic>)>()
        .map((e) => e.$2)
        .toList();
    print(targets);

    for (final target in targets) {
      target.handle(value);
    }
  }
}

void main() {
  final comms = Comms();
  comms.addSink(Consumer<int>());
  comms.addSink(Consumer<num>());
  comms.addSink(Consumer<double>());
  comms.addSink(Consumer<String>());
  comms.addSink(Consumer<Object>());

  comms.sendEvent<int>(1);

  comms.sendEvent<num>(1);
}
