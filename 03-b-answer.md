# 03-b: イミュータブルクラス（ Computed Property ） 解答の解説

色々とやり方はありますが、 `03-b-answer.swift` では `Character` 同様に `Party` にも `copy` メソッドを実装しました。

```swift
extension Party {
    ...
    func copy(leader: Character? = nil) -> Party {
        guard let leader = leader else { return self }
        var members = self.members
        members[0] = leader
        return Party(members: members)
    }
}
```

これを使えば `Party` インスタンスの状態を変更した新規インスタンスを生成できますが、これと `performAttack` をうまくつなぐことができません。結局、 `performAttack` を呼び出す箇所では、次のように一度変数 `target` を経由しなければなりませんでした。

```swift
for character in friendParty.members {
    var target = enemyParty.leader
    performAttack(by: character, to: &target)
    enemyParty = enemyParty.copy(leader: target)
}
```

イミュータブルクラスのインスタンスを変更しようと思った場合、 01-b2 で見たように、あるプロパティを直接変更するだけならそれほど大変ではありません。

```swift
hero = hero.copy(hp: hero.hp - damage)
```

しかし、今回のようにネストしたインスタンスの深いところ（ `Party` の `members[0]` の `hp` ）を変更しようとすると、根本（ `Party` ）まですべてインスタンスを作り直さないといけないから大変です。

## 発展

Haskell のような関数型言語ではすべてがイミュータブルです。同じような問題は起こらないのでしょうか？

Haskell ではこのような問題に対処するために `Lens` というものを使います。[こちら](http://chris.eidhof.nl/post/lenses-in-swift/)では `Lens` とはどういうものかが Swift を使って解説されています。今日の主題からずれてしまうのでこれ以上深入りはしませんが、興味がある方は後で覗いてみて下さい。
