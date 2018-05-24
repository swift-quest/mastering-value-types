# 07-a: ミュータブルクラス（複数インスタンスの変更・その 2 ） 解答の解説

`performSpell` の最初に `defer { print() }` をしているのは、 `guard` を挿入したために改行のためのコードが複数箇所に分散されることを防ぐための措置です。このように、特に早期脱出のための分岐が存在するときに、漏れなく終了処理を行うには `defer` が便利です。

`defer` を使わない場合から差分は次の通りです。

```diff
 func performSpell(_ spell: Spell, by character: Character, to target: Character) {
+    defer { print() }
+
     print("\(character.name)は\(spell.name)のまほうをつかった。")

     guard character.mp >= spell.mp else {
         print("しかしMPがたりない。")
-        print()
         return
     }

     character.mp -= spell.mp

     switch spell {
     case .attack(_, _, let damage):
         target.hp -= damage
         print("\(target.name)に\(damage)のダメージ！")
     }

-    print()
 }
```

---

- [次の課題](07-c.md)
