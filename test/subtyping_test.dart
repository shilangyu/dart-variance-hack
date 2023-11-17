import 'dart:collection';

import '_.dart';

bool isSubtype<T, U>() {
  return <T>[] is List<U>;
}

bool isSubtypeInstances<T, U>(T val, U sup) {
  return val is U;
}

bool hasSameType(dynamic a, dynamic b) {
  return a.runtimeType == b.runtimeType;
}

void main() {
  test('`is` requires instance + type!', () {
    show(123 is Object);
  });

  test('wrong because used types on both sides, right?', () {
    show(int is int);
  });

  test('so this is also wrong, right?', () {
    show(Object is Object);
  });

  test('here `Object` is an instance of a `Type`!', () {
    show(Object is Type);
  });

  test('subtyping check without instances!', () {
    show(isSubtype<int, num>());
  });

  test('subtyping check instances!', () {
    final num v = 321;
    show(isSubtypeInstances(123, v));

    // not very useful, requires compile time knowledge of types
    // above function hides the fact that type parameters were inferred, not gathered from runtime information
  });

  test('only checks exact types', () {
    show(123.runtimeType == num);
  });

  test('dart has primitive union types', () {
    final int? a = null;
    final int? b = 123;
    show(
      a is int, // runtime check of union variant
      b is int,
      isSubtype<int, int?>(),
      isSubtype<Null, int?>(),
    );
  });

  test('hardcoded union type', () {
    final FutureOr<int?> a = null;
    final FutureOr<int?> b = 123;

    final _ = switch (b) {
      final Future<int?> _ => 1,
      final int _ => 2,
      null => 2,
    };
    show(
      a is int,
      b is int,
      isSubtype<Future<int>, FutureOr<int>>(),
      isSubtype<int, FutureOr<int>>(),
    );
  });

  test('top/bot type', () {
    show(
      isSubtype<List<int>, dynamic>(),
      isSubtype<Never, List<int>>(),
    );
  });

  test('subtyping is reflexive', () {
    show(
      isSubtype<int, int>(),
      isSubtype<Never, Never>(),
      isSubtype<dynamic, dynamic>(),
    );
  });

  test('subtyping is transitive', () {
    show(
      isSubtype<UnmodifiableListView, List>(),
      isSubtype<List, Iterable>(),
      isSubtype<UnmodifiableListView, Iterable>(),
    );
  });

  // subtyping is anti-symmetric, to be seen later
  // if T1 <: T2 and T2 <: T1 then T1 == T2
}
