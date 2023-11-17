class Consumer<in T> {
  void handle(T sth) {
    print('doing $sth');
  }
}


void main() {
  final List<Consumer<Never>> handlers = [
    Consumer<int>(),
    Consumer<num>(),
    Consumer<double>(),
    Consumer<String>(),
    Consumer<Object>(),
  ];

  void sendEvent<T>(T value) {
    for (var i = 0; i < handlers.length; i++) {
      if (handlers[i] case Consumer<T> handler) {
        handler.handle(value);
      }
    }
  }

  sendEvent<num>(1);
}
