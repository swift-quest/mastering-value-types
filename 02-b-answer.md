# 02-b: イミュータブルクラス（関数） 解答の解説

`copy` メソッド同様に、イミュータブルクラスを用いて状態を変更したい場合の定石は、新規新スタンスを生成して `return` することです。

そのため、ダメージ分だけ `hp` を減らされた新規 `Character` インスタンスを生成して `return` するように `performAttack` を修正します。

```diff
-func performAttack(by character: Character, to target: Character) {
+func performAttack(by character: Character, to target: Character) -> Character {
     ...
 }
```

次に、 `target` の `hp` を減らす部分を `copy` を使って書き換えます。

```diff
     let damage = Swift.max(0, (character.attack - target.defense) / 2)
-    target.hp -= damage
+    target = target.copy(hp: target.hp - damage)
```

しかし、この `target` は引数で与えられたもので定数なのでこのままでは再代入ができません。 Swift 3.0 からは引数に `var` を付けることもできなくなってしまったので、次のようにして変数の `target` を作ります（ Swift では関数やメソッドのローカルスコープに引数と同名の変数を宣言できます）。

```diff
 func performAttack(by character: Character, to target: Character) -> Character {
+    var target = target
+
     print("\(character.name)のこうげき。")
```

そして、この `target` を `return` すれば `performAttack` は完成です。

```diff
 func performAttack(by character: Character, to target: Character) -> Character {
     ...
     print("\(target.name)に\(damage)のダメージ！")
     print()
+
+    return target
 }
```

最後に、 `main` の中で `performAttack` を使っている箇所を修正します。 `performAttack` を呼び出すだけではインスタンスを更新して `hp` を減らすことはできないので、再代入が必要となります。

```diff
-performAttack(by: hero, to: archfiend)
+archfiend = performAttack(by: hero, to: archfiend)
-performAttack(by: archfiend, to: hero)
+hero = performAttack(by: archfiend, to: hero)
```

---

- [次の課題](02-b2.md)
