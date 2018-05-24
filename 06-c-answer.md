# 06-c: 値型（複数インスタンスの変更） 解答の解説

`performSpell` では `character` の MP を減らさないといけないので、 `performAttack` と異なり `character` も `inout` にしなければなりません。

```swift
func performSpell(_ spell: Spell, by character: inout Character, to target: inout Character) {
    ...
}
```

---

- [次の課題](07-a.md)
