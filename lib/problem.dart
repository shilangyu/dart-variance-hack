class Consumer<T> {
  void handle(T sth) {
    print('doing $sth');
  }
}

void main() {
  final List<Consumer<dynamic>> handlers = [
    Consumer<int>(),
    Consumer<num>(),
    Consumer<double>(),
    Consumer<String>(),
    Consumer<Object>(),
  ];

  void sendEvent<T>(T value) {
    final targets = handlers.whereType<Consumer<T>>();
    print(targets);

    for (final target in targets) {
      target.handle(value);
    }
  }

  sendEvent<num>(1);
}
