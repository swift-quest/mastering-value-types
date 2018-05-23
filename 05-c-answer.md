# 05-c: 値型（メソッドによる選択） 解答の解説

02-b2 で

> `mutating func` は `self` を `inout` で渡すことと同じ

と言いましたが、 `05-c-answer.swift` ではまさにそれが体現されています。

`04-c2-answer.swift` の `any(of:_:)` は次のようになっていました。

```swift
func any<C: MutableCollection>(
    of collection: inout C,
    operation: (inout C.Element) throws -> ()
) rethrows where C.Index == Int
```

`05-c-answer.swift` の `updateRandomElement(using:_:)` を比較すると、 `inout` パラメータが `mutating func` の暗黙の引数 `self` に置き換わっているのがよくわかります。

```swift
mutating func updateRandomElement<T: RandomNumberGenerator>(
    using generator: inout T,
    _ operation: (inout Element) throws -> ()
) rethrows
```

呼び出し箇所を比較してみてもおもしろいです。

```swift
// 04-c2
any(of: &enemyParty.members) { performAttack(by: character, to: &$0) }

// 05-c
enemyParty.members.updateRandomElement(using: &generator) {
    performAttack(by: character, to: &$0)
}
```

第一引数で渡していた `enemyParty.members` がメソッドのレシーバーとして暗黙に渡されています。

なお、 `updateRandomElement` を `Collection` ではなく `MutableCollection` の `extension` としているのは、 `subscript { set }` が `MutableCollection` でないと使えないからです。
