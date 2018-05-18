# 02-c: 値型（関数） 解答の解説

`02-c-answer.swift` を `02-a-answer.swift` と見比べてみて下さい。

主な変更点は次の 2 箇所だけです。

```diff
-func performAttack(by character: Character, to target: Character) {
+func performAttack(by character: Character, to target: inout Character) {
     ...
 }
```

```diff
 func main() {
     ...
-    performAttack(by: hero, to: archfiend)
-    performAttack(by: archfiend, to: hero)
+    performAttack(by: hero, to: &archfiend)
+    performAttack(by: archfiend, to: &hero)
     ...
 }
```

処理を `performAttack` 関数に括りだした場合でも、ミュータブルクラスのコードとほとんど同じように値型のコードが書けているのがわかります。参照渡しはモダン言語では倦厭される言語機能の一つですが、**値型でミュータブルクラスの利便性とイミュータブルクラスの安全性を実現するには `inout` を使いこなすことが欠かせません**。
