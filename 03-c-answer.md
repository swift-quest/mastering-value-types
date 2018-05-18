# 03-b: 値型（ Computed Property ） 解答の解説

`03-c-answer.swift` の `03-a-answer.swift` からの主な変更点は、 `performAttack` の呼び出し時に `&` を付けたことだけです。

```diff
 for character in friendParty.members {
-        performAttack(by: character, to: enemyParty.leader)
+        performAttack(by: character, to: &enemyParty.leader)
 }

 for character in enemyParty.members {
-        performAttack(by: character, to: friendParty.leader)
+        performAttack(by: character, to: &friendParty.leader)
 }
```

イミュータブルクラスではずいぶんと大変でしたが、値型であればインスタンスがネストしてもミュータブルクラスとほぼ同じコードで状態を変更できました。しかも、繰り返しになりますが、このコードの `Character` や `Party` は `struct` なので、インスタンスが共有されることがなく、イミュータブルクラス同様に安全です。

意識しないと気付きづらいですが、上記のコードは Swift の特殊な言語機能によって動作します。たとえば、 C# には `struct` と参照渡し（ `ref` ）がありますが同様のことはできません。なぜでしょうか？

これを理解するために、次のようなコードを考えてみます。 Swift ではこれは問題なく動作します。

```swift
var party = ...
party.leader.hp -= 10 // OK ✅
```

これは当たり前のように思えるかもしれませんが、実はそれほど当たり前のことではありません。 C# では次のようなコードを書かなくてはいけません（↓のコードは Swift で書かれていますが、 C# ではこれに相当するコードを書かなければならないという意味です）。

```swift
var party = ...
var leader = party.leader
leader.hp -= 10
party.leader = leader
```

なぜ C# では `party.leader.hp -= 10` ができないのでしょうか？次に↓のコードを考えてみましょう。これは Swift でもコンパイルエラーになります。

```swift
var party = ...
party.getLeader().hp -= 10 // NG ⛔
```

これができないのは当たり前です。 `party.getLeader()` が返すのは `getLeader` の中で計算され、一時的にメモリ上に存在する値で、仮にこれを更新できたとしても次の瞬間には消えてしまいます。そのため、値型の戻り値を直接更新しても意味がありません。無意味なことを防ぐためにコンパイルエラーとなるようになっているわけです。

`leader` は Computed Property なので、この `getLeader` メソッドと同じような存在です。そう考えると `party.leader.hp -= 10` ができない方が自然に思えます。

`=` の左に書くことができる値を **_左辺値（ lvalue ）_** と言います。 _左辺値_ の代表格は変数ですが、その他にもプロパティや `subscript` などがあります。また、 `foo.bar.baz` のように連続的にプロパティにアクセスした場合も、途中がすべて Stored Property の場合には _左辺値_ になれる言語が多いです。

```swift
party = anotherParty     // 変数 ✅
character.hp = 0         // Stored Property ✅
party.leader = character // Computed Property ✅
members[i] = character   // Subscript ✅
```

C# では途中に値型の Computed Property が挟まった場合には _左辺値_ でなくなってしまいます。そのため、 `party.leader.hp -= 10` のようなコードがコンパイルエラーになってしまうわけです。

```swift
party = anotherParty     // 変数 ✅
character.hp = 0         // Stored Property ✅
party.leader = character // Computed Property ✅
members[i] = character   // Subscript ✅

// C#
party.leader.hp -= 10    // Computed Property を経由 ⛔
      ^^^^^^
```

しかし、 Swift では Computed Property が間に挟まっても _左辺値_ になります。そのおかげで `party.leader.hp -= 10` のような式を書くことができます。

```swift
party = anotherParty     // Variables ✅
character.hp = 0         // Stored Properties ✅
party.leader = character // Computed Properties ✅
members[i] = character   // Subscripts ✅

// Swift
party.leader.hp -= 10    // Computed Property を経由 ✅
      ^^^^^^
```

では、　Computed Property が間に挟まった場合、 Swift はどうやってそれを _左辺値_ として扱っているんでしょうか。

```swift
var party = ...
party.leader.hp -= 10 // OK ✅
```

↑のコードは実は↓コードと同じように動きます。 `hp` だけを変更してるつもりでも、 Computed Property を経由すると `leader` の `set` も呼ばれて `Character` 全体を代入することになっている点に注意して下さい。

```swift
var party = ...
var leader = party.leader
leader.hp -= 10
party.leader = leader
```

Swift では、 Computed Property を経由する式でも、このような仕組みで _左辺値_ として取り扱えるようになっています。

## 参照型との比較

参照型にとっては Computed Property を経由しても左辺値になれることは当然のことです。参照型では次のようなコードでもエラーになりません。

```swift
// class Party
let party = ...
party.getLeader().hp -= 10 // OK ✅
```

参照型の場合、 `getLeader()` の返すインスタンスは共有され得るので、戻り値であってもどこか別のところから参照されているかもしれません。そのため、戻り値に変更を加えることが意味を持つことがあります。そのため、参照型であれば戻り値に変更を加えるコードもコンパイルエラーになりません。

言い換えると、値型で `party.leader.hp` を _左辺値_ にできるというのは、 `struct` でもミュータブルクラスと同様のことができるようにするための言語仕様だと言えます。

```swift
// class Party
let party = ...
party.leader.hp -= 10 // OK ✅

// struct Party
var party = ...
party.leader.hp -= 10 // OK ✅
```

これまで見てきたように、値型を使えばミュータブルクラスの利便性とイミュータブルクラスの安全性のいいとこどりができるわけですが、それを実現するためには Computed Property を経由しても _左辺値_ になるという言語仕様が欠かせないわけです。
