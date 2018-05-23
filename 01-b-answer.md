# 01-b: イミュータブルクラス 解答の解説

イミュータブルクラスのインスタンスは更新することができないので、イミュータブルクラスを使って状態を変更する際にはインスタンスを丸ごと作り替える必要があります。

[01-b-answer.swift](01-b-answer.swift) では、次のようにして `hp` を `damage` の分を減らし、それ以外はまったく同じ `Character` インスタンスを丸ごと再生成しています。

```swift
hero = Character(
    name: hero.name,
    hp: hero.hp - damage,
    mp: hero.mp,
    attack: hero.attack,
    defense: hero.defense
)
```

ここで注意が必要なのは、再生成したインスタンスを `hero` に再代入していることです。ミュータブルクラスのときは `hero` は定数（ `let` ）でしたが、イミュータブルクラスでは状態を更新するために再代入が必要となるので変数（ `var` ）である必要があります。 [01-b-answer.swift](01-b-answer.swift) では、 `hero` に合わせて `archfiend` も `var` にしています（このため実行時に警告が出ますが気にしないで下さい）。

```diff
-let hero = Character(name: "ゆうしゃ", hp: 153, mp: 25, attack: 162, defense: 97)
-let archfiend = Character(name: "まおう", hp: 999, mp: 99, attack: 185, defense: 58)
+var hero = Character(name: "ゆうしゃ", hp: 153, mp: 25, attack: 162, defense: 97)
+var archfiend = Character(name: "まおう", hp: 999, mp: 99, attack: 185, defense: 58)
```

もう一点気を付けたいのは、クラスがミュータブルであるかイミュータブルであるかということと、そのインスタンスが格納されるのが変数であるか定数であるかということは直交する概念だということです。これらは互いに独立で、次のすべての組み合わせがありえます。

|   | ミュータブルクラス | イミュータブルクラス |
|:--:|:--:|:--:|
| 変数 | `var a: MutableClass= ...` | `var a: ImmutableClass = ...` |
| 定数 | `let a: MutableClass= ...` | `let a: ImmutableClass = ...` |

これはわかってしまえば当たり前のことですが、混同されがちなので区別して理解することが重要です。

---

- [次の課題](01-b2.md)
