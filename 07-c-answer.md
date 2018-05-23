# 07-c: 値型（複数インスタンスの変更・その 2 ） 解答の解説

[06-c-answer.swift](06-c-answer.swift) でやったように、 `performAttack` の第 1 引数 `character` を `inout` パラメータにしようとすると、呼び出し側で困ったことになります。 [03-c-answer.swift](03-c-answer.swift) の呼び出し側は次のようになっていました。

```swift
for character in friendParty.members {
    performAttack(by: character, to: &enemyParty.leader)
}
```

この `character` は定数なので `&character` として渡すことはできません。しかし、次のように変数にしたからといって問題が解決するわけではありません。

```swift
for var character in friendParty.members {
    performAttack(by: &character, to: &enemyParty.leader)
}
```

これだとコンパイルは通るようになりますが、 `character` への変更は捨てられてしまい、元の `friendParty.members` に反映されることはありません。

[04-c2-answer.swift](04-c2-answer.swift) で考えたように `inout` パラメータを持つ高階関数を使えばこの `for` 文を置き換えることができます。ここでは、 [04-c2-answer.md](04-c2-answer.md) で考えた `update` メソッドを導入しました。（ただし、 `Array` に対してではなく、より一般的に `MutableCollection` に対して実装しました。）

```swift
extension MutableCollection {
    mutating func update(_ operation: (inout Element) -> Void) {
        for index in indices {
            operation(&self[index])
        }
    }
}
```

これを使えば前述の `for` ループを次のように書き換えることができます。

```swift
friendParty.members.update { character in
    performAttack(by: &character, to: &enemyParty.leader)
}
```

これなら、 [07-a-answer.swift](07-a-answer.swift) と似たようなシンプルさで記述できます。

```swift
// 07-a-answer.swift
for character in friendParty.members {
    performAttack(by: character, to: enemyParty.leader)
}
```

---

- [次の課題](08-a.md)
