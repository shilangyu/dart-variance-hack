class Super {}

// Sub <: Super
class Sub extends Super {}

typedef Contra<T> = void Function(T);
Contra<T> makeContra<T>() => (T _) {};

typedef Cov<T> = T Function();
Cov<T> makeCov<T>(T val) => () => val;

typedef Inv<T> = T Function(T);
Inv<T> makeInv<T>(T val) => (T _) => val;

void main() {
  printInfo('natural', Sub(), Super());
  printInfo('contravariant', makeContra<Sub>(), makeContra<Super>());
  printInfo('covariant', makeCov<Sub>(Sub()), makeCov<Super>(Super()));
  printInfo('invariant', makeInv<Sub>(Sub()), makeInv<Super>(Super()));
}

void printInfo<Sub, Sup>(String name, Sub sub, Sup sup) {
  print(name);
  print('Sub is Super\t${sub is Sup}');
  print('Super is Sub\t${sup is Sub}');
  print('');
}
