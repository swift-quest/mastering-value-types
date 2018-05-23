# 04-c: 値型（関数による選択） 解答の解説

`any(of:)` で `Character` インスタンスを選択すると、その戻り値は _左辺値_ ではないので参照渡しすることができません。

そのため、 [04-c-answer.swift](04-c-answer.swift) では `members` からインデックスを選択するのに `any(of:)` を使い、 `performAttack` へは `subscript` を参照渡しするようにしています。

```swift
for character in friendParty.members {
    let index = any(of: enemyParty.members.indices)!
    performAttack(by: character, to: &enemyParty.members[index])
}
```

`subscript` の結果が参照渡しできるのは、 Swift の `subscript` は Computed Property と同じように働き _左辺値_ になることができるからです。

しかし、 [04-a-answer.swift](04-a-answer.swift) のミュータブルクラスのときのコード（下記）と比べると随分と複雑になってしまいました。

```swift
for character in friendParty.members {
    performAttack(by: character, to: any(of: enemyParty.members)!)
}
```

---

- [次の課題](04-c2.md)
