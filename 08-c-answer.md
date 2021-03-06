# 08-c: 値型（複数インスタンスの変更・その 3 ） 解答の解説

Swift の `inout` パラメータは強力な機能ですが、限界もあります。

[Ownership Manifesto](https://github.com/apple/swift/blob/master/docs/OwnershipManifesto.md) （[日本語による解説](https://qiita.com/omochimetaru/items/c5f0eabde516e4713367)）の中で提唱されていた排他則が Swift 4 で導入されました。

排他則の例を見てみましょう。

Swift の標準ライブラリには `swap` という関数があります（[リファレンス](https://developer.apple.com/documentation/swift/1540890-swap)）。

```swift
func swap<T>(_ a: inout T, _ b: inout T)
```

これは `a` と `b` を入れ替えるもので、次のように使えます。

```swift
var a = 2
var b = 3

swap(&a, &b)

print(a) // 3
print(b) // 2
```

しかし、次のようなコードはコンパイルエラーとなります。

```swift
var a = 2
swap(&a, &a) // コンパイルエラー
```

これは、排他則に引っかかったからです。

[04-c2-answer.md](04-c2-answer.md) で説明したように、 Swift の参照は第一級の存在ではありません。危険なことができないように注意深く設計されています。排他則の導入によってそれがより推し進められた形です。

もし `swap(&a, &a)` のように `inout` パラメータに同じ値の参照を渡すことができると、値型のインスタンスが異なる変数（引数）間で共有されてしまうことになります。排他則はそのような事態を防ぐのに役立ちます。

しかし、これが不便を引き起こすこともあります。たとえば、 Swift では次のようなことができません。

```swift
var a = [2, 3, 5]
swap(&a[0], &a[2]) // コンパイルエラー
```

`a[0]` と `a[2]` が指す領域は異なりますが、 [03-c-answer.md](03-c-answer.md) で説明したように、

```swift
var party = ...
party.leader.hp -= 10
```

のコードは実際には

```swift
var party = ...
var leader = party.leader
leader.hp -= 10
party.leader = leader
```

のように動作します。同じように `&a[0]` で渡された `inout` パラメータに対する変更は、連鎖的に `a` の `subscript { set }` を呼び出し、 `a` 自体に対する変更となります。そのため、 `&a[0]` は `a` に対する変更を排他的に扱わなければならないのです。そのため、 `&a[0]` と `&a[2]` は競合し、コンパイルエラーになってしまいます。

しかし、 `Array` の要素を交換できないのは不便です。そのようなケースに対応するために、 `MutableCollection` は `swapAt` というメソッドを提供しています。

```swift
mutating func swapAt(_ i: Self.Index, _ j: Self.Index)
```

```swift
var a = [2, 3, 5]
a.swapAt(0, 2)
print(a) // [5, 3, 2]
```

これでやりたいことができるとはいえ、苦肉の策という感じです。安全性のためとはいえ、やはり直接 `swap(&a[0], &a[2])` ができないのは `inout` パラメータの限界を感じさせます。

同じことが [08-c](08-c.md) にも言えます。 `performSpell` を呼びコードを素直に実装すると次のようになります。

```swift
friendParty.members.update { character in
    performSpell(.healing, by: &character, to: &friendParty.leader)
}

enemyParty.members.update { character in
    performSpell(.healing, by: &character, to: &enemyParty.leader)
}
```

このとき、 `friendParty.members.update { ... }` は `friendParty` に対する変更となります。つまり、排他則によってこのクロージャ式の中では `friendParty` にアクセスすることはできません。しかし、 `&friendParty.leader` があるので排他則に引っかかります。

排他則を回避するために次のようなコードを書いた場合を考えてみましょう。

```swift
for i in friendParty.members.indices {
    var target = friendParty.leader; defer { friendParty.leader = target }
    performSpell(.healing, by: &friendParty.members[i], to: &target)
}
```

しかし、勇者が勇者自身にヒーリングを使う場合、 MP を消費する勇者と回復される勇者が異なるインスタンスとなり、どちらかの処理結果が無視されてしまいます。上記のコードでは、 MP の消費が無視されています。

これまで値型と `inout` パラメータを駆使してミュータブルクラスと同じように簡単に状態を変更できることを目指してきましたが、ここに限界があります。

とはいえ、 RPG のような複雑なロジックでなければ、実際のアプリケーションで排他則にひっかかるようなケースは稀なはずです。値型と `inout` パラメータが強力な武器であることには変わりありません。
