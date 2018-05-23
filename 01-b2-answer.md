# 01-b2: イミュータブルクラス 解答の解説

`Character` にダメージを与えて `hp` を減らすコードを簡単に書けるようにする方法はいくつかあります。

一番最初に思いつくのは `Character` クラスに次のようなメソッドを追加することです。

```swift
extension Character {
    func takeDamage(_ damage: Int) -> Character {
        return Character(
            name: name,
            hp: hp - damage,
            mp: mp,
            attack: attack,
            defense: defense
        )
    }
}
```

この `takeDamage` メソッドを使えば簡単にダメージ分だけ `hp` を減らすことができます。

```swift
hero = hero.takeDamage(damage)
```

しかし、回復魔法で HP を回復するパターンも考えると、 `hero.takeDamage(-restoration)` のようにして回復させるのは不細工なので、次のような `increaseHP` メソッドにした方が良いでしょう。


```swift
extension Character {
    func increaseHP(by amount: Int) -> Character {
        return Character(
            name: name,
            hp: hp + amount,
            mp: mp,
            attack: attack,
            defense: defense
        )
    }
}
```

```swift
hero = hero.increaseHP(by: -damage)
```

ただし、この `increaseHP` メソッドにも問題があります。 `hp` を全回復させる魔法や、即死魔法など、 `hp` の増減ではなくある値を指定したい場合には使いづらいということです。

そこで、増減に特化するのではなく、より汎用的な `updateHP` メソッドを作ります。

```swift
extension Character {
    func updateHP(_ hp: Int) -> Character {
        return Character(
            name: self.name,
            hp: hp,
            mp: self.mp,
            attack: self.attack,
            defense: self.defense
        )
    }
}
```

```swift
hero = hero.updateHP(hero.hp - damage)
```

では、魔法を使ったときに `mp` を増減させたければどうすれば良いでしょう？同じように `updateMP` メソッドを作れば良いでしょうか？

次のように、まとめて一つのメソッドにしてしまう方法もあります。

```swift
extension Character {
    func update(hp: Int, mp: Int) -> Character {
        return Character(
            name: self.name,
            hp: hp,
            mp: mp,
            attack: self.attack,
            defense: self.defense
        )
    }
}
```

しかし、これでは `hp` だけ変更したいときに `mp` についても記述しなければならず面倒です。

```swift
hero = hero.update(hp: hero.hp - damage, mp: hero.mp)
```

そこで、 `update` メソッドを改良して次のように改良してみます。

```swift
extension Character {
    func update(hp: Int? = nil, mp: Int? = nil) -> Character {
        return Character(
            name: self.name,
            hp: hp ?? self.hp,
            mp: mp ?? self.mp,
            attack: self.attack,
            defense: self.defense
        )
    }
}
```

こうしておけば変更する必要のない値は記述を省略できますし、 `hp` でも `mp` でも、その両方でも自由に変更することができます。

```swift
hero = hero.update(hp: hero.hp - damage)
```

さて、この `update` メソッドがおもしろいのは、引数を何も与えないとただのコピーになることです。

```swift
let copied = hero.update()
```

そう考えると、このメソッドはインスタンスのコピーを作成するメソッドに、変更したい値をオプションで与えるものだと考えることもできます。

そこで、 [01-b2-answer.swift](01-b2-answer.swift) ではこれを `copy` メソッドとしました。

```swift
extension Character {
    func copy(hp: Int? = nil, mp: Int? = nil) -> Character {
        return Character(
            name: self.name,
            hp: hp ?? self.hp,
            mp: mp ?? self.mp,
            attack: self.attack,
            defense: self.defense
        )
    }
}
```

```swift
hero = hero.copy(hp: hero.hp - damage)
```

実際、 [Kotlin](https://kotlinlang.org/) ではデータクラスという特殊なクラスを作ったときに、自動的にこのような `copy` メソッドが生成されます。

```kotlin
// Kotlin
data class Character(
    val name: String, // 名前
    val hp: Int,      // HP
    val mp: Int,      // MP
    val attack: Int,  // 攻撃力
    val defense: Int  // 防御力
)
```

```kotlin
// Kotlin
hero = hero.copy(hp = hero.hp - damage)
```

Swift には値型があるのでイミュータブルクラスの便利な代替になりますが、 Kotlin には参照型しかないのでイミュータブルクラスとうまく付き合うことは必須です。そこで、 Kotlin ではデータクラスであれば `copy` メソッドが自動生成されるようになっているというわけです。これは、 Swift で `Equatable` や `Hashable`, `Codable` の実装コードが自動生成されるのと似ています。 Swift も Kotlin もモダン言語に挙げられますが、ボイラープレートを減らすためにコンパイラがコード生成をするという同じ解決策に至っているのがおもしろいですね。

---

- [次の課題](01-c.md)
