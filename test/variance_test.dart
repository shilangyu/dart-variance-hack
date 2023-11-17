import '_.dart';
import 'subtyping_test.dart';

bool isSupertype<T, U>() {
  return (T _) {} is Function(U);
}

void main() {
  test('all generics in dart are covariant', () {
    final List<Object> a = <int>[1];
    show(
      <int>[] is List<Object>,
      <Object>[] is List<int>,
      a is List<int>,
    );
  });

  test('which is not good', () {
    final l = [1, 2, 3];
    // variable assignment is possible only if `l2` is a subtype of `l`
    // since List is covariant, we can legally generalize the type
    final List<Object> l2 = l;
    l2.add('oops');
  });

  test('contravariance exists only in function parameters', () {
    show(
      isSubtype<num, int>(),
      isSubtype<num Function(), int Function()>(),
      isSubtype<Function(num), Function(int)>(),
    );
  });

  test(
      'if a type is both covariant and contravariant, then it is invariant (due to antisymmetry)',
      () {
    show(
      isSubtype<num Function(num), int Function(int)>(),
      isSubtype<int Function(int), num Function(num)>(),
    );
  });

  test('what if generic is a contravariant type?', () {
    show(
      isSubtype<List<Function(num)>, List<Function(int)>>(),
      isSubtype<MapEntry<Function(num), int>, MapEntry<Function(int), num>>(),
    );
  });

  test('isSupertype', () {
    show(isSupertype<num, int>());
  });

  // there is NO way to make your generic contravariant
}
