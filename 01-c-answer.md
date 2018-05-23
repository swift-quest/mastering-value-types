# 01-c: 値型（ `struct` ） 解答の解説

[01-c-answer.swift](01-c-answer.swift) では `Character` の `hp` を次のようにして変更しています。

```swift
hero.hp -= damage
```

これは [01-a-answer.swift](01-a-answer.swift) と完全に同じです。つまり、 `struct` を使えばミュータブルクラスと同じように簡単にインスタンスの状態を変更することができるということです。

しかし、この `Character` はミュータブルクラスの `Character` とは違い、値型なのでインスタンスが共有されることがありません。

次の二つは同じようなコードですが、ミュータブルクラスと `struct` では結果が異なります。

```swift
// `Character` がミュータブルクラスの場合
let foo = hero
foo.hp -= damage // `hero` の `hp` も減る
```

```swift
// `Character` が `struct` の場合
var foo = hero
foo.hp -= damage // `hero` の `hp` は減らない
```

また、同様のことをイミュータブルクラスですると次のようになります。

```swift
// `Character` がイミュータブルクラスの場合
var foo = hero
foo.copy(hp: foo.hp - damage) // `hero` の `hp` は減らない
```

処理の結果はイミュータブルクラスと `struct` で同じになります。

つまり、 **`struct` はミュータブルクラスの利便性とイミュータブルクラスの安全性を兼ね備えている存在** だと言うことができるわけです。

しかし、今のようなシンプルなケースではそれは真ですが、より複雑なケースでは工夫が必要となります。 `struct` でミュータブルクラスのような利便性を実現するためにどのような工夫が必要なのか、これから徐々にコードを複雑にしながら考えてみましょう。

---

- [次の課題](02-a.md)
