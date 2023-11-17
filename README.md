# Hacking contravariance in Dart

<details>
<summary>Prerequisite knowledge</summary>

1. `T <: U` denotes that `T` is a subtype of `U`. Similarly `T :> U` means that `T` is a supertype of `U`.
2. Variance defines how should subtyping behave in presence of type parameters.
3. A top type is a type that is a supertype of all other types. A bottom type is a type that is the subtype of all other types.

</details>

The Dart programming language does not allow programmers to decide on the variance of type parameters. All generics are covariant leading to well-known issues when combined with subtyping:

```dart
List<int> list = [1, 2, 3];

List<Object> newList = list; // ok because int <: Object so therefore List<int> <: List<Object>

newList.add('oops'); // runtime error
```

Languages that allow to control variance typically have a mutable and immutable kind of a list with an invariant and covariant type argument respectively. In Dart there is no such thing, so nothing prevents us from these runtime errors. See [subtyping_test.dart](test/subtyping_test.dart) and [variance_test.dart](test/variance_test.dart) for an introduction to subtyping and variance in Dart.

A popular example where lack of contravariance is detrimental is a consumer class:

```dart
class Consumer<T> {
  void handle(T sth) {
    print('doing $sth');
  }
}
```

If we were to store a list of consumers and later wanted to retrieve those consumers which can accept a type `R`, we would quickly realize it harder than it initially seemed. Naively one could filter this list by those consumers that are subtypes of `Consumer<R>`. Take for example the hierarchy `int <: num <: Object`. If we were to filter by `num` we would get all consumers such that `<: Consumer<num>`. But this is not correct: we cannot pass in a `num` to a consumer which expects an `int`, and yet `Consumer<int> <: Consumer<num>`. See [problem.dart](lib/problem.dart) for an example of the problem.

In fact we need the reverse relationship, we want all consumers such that `:> Consumer<num>`. Since there is nothing we can do with this problem at the declaration-site, we need to resort to hacking use-site variance. There is one type in Dart that can simulate contravariance: the function type. Arguments of a function are contravariant, so `void Function(num) <: void Function(int)` because `num :> int`. We can use this fact to achieve use-site variance. See [variance.dart](lib/variance.dart) to see how to achieve objects which are covariant, contravariant, and invariant.

Instead of storing a list of consumers alone, we will pair each consumer with a "tag" that exhibits contravariance behavior. Then when looking for compatible consumers we will filter by that tag rather than the consumer type. See [solution.dart](lib/solution.dart) for implementation.

---

The Dart language has had an experimental feature for [declaration-site variance specifiers](https://github.com/dart-lang/language/issues/524) for a while now. This solves all presented issues and moves the responsibility of correctly specifying variance to the type declaration. See [explicit_variance.dart](lib/explicit_variance.dart) for a preview of this feature (run with `--enable-experiment=variance`).
