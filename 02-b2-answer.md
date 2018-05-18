# 02-b2: イミュータブルクラス（関数） 解答の解説

`02-b2-answer.swift` はただ `performAttack` を `inout` を使って書き直しただけなので説明は省略します。ここでは、「発展」の問の答えについて解説します。

`copy` は次のようなメソッドでした。

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

一方で、 `performAttack` のシグネチャは次のようになっていました。

```swift
func performAttack(by character: Character, to target: inout Character)
```

`performAttack` の `target` のように、 `inout` は引数に対して用いることができますが、 `copy` で変更したいのは引数に渡されるインスタンスではなくメソッドを呼び出すインスタンス自身（メソッドのレシーバー）です。レシーバーに対して `inout` を書くことはできません。

もし `copy` がメソッドではなく関数であれば話は簡単です。

```swift
func copy(_ character: Character, hp: Int? = nil, mp: Int? = nil) -> Character {
    return Character(
        name: character.name,
        hp: hp ?? character.hp,
        mp: mp ?? character.mp,
        attack: character.attack,
        defense: character.defense
    )
}
```

第 1 引数の `character` に `inout` を付与して戻り値をなくすことができます。

```swift
func copy(_ character: inout Character, hp: Int? = nil, mp: Int? = nil) {
    character = Character(
        name: character.name,
        hp: hp ?? character.hp,
        mp: mp ?? character.mp,
        attack: character.attack,
        defense: character.defense
    )
}
```

これを使えば、たとえ `Character` がイミュータブルなクラスでも、冗長な再代入なしに `hp` を減らすことができます。

```swift
copy(&target, hp: target.hp - damage)
```

メソッド版の `copy` と関数版の `copy` を見比べるとわかりますが、メソッドというのは暗黙の第 1 引数 `self` が渡されている関数だと解釈することができます。わかりやすいように、 `character` を `zelf` に変えて並べてみます。

```swift
// メソッド
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

// 関数
func copy(_ zelf: Character, hp: Int? = nil, mp: Int? = nil) -> Character {
    return Character(
        name: zelf.name,
        hp: hp ?? zelf.hp,
        mp: mp ?? zelf.mp,
        attack: zelf.attack,
        defense: zelf.defense
    )
}
```

`self` (`zelf`) が暗黙の引数になっているか明示的な第 1 引数になっているかだけの違いで、処理の中身は完全に同じです。

使うときも、 `instance.foo(...)` の形で呼び出すか、 `foo(instance, ...)` の形で呼び出すかが異なるだけで結果は変わりません。

```swift
// メソッド
target = target.copy(hp: target.hp - damage)

// 関数
target = copy(target, hp: target.hp - damage)
```

メソッドを、レシーバーが暗黙の引数 `self` になる関数だと考えると、 `inout` の変わりに `self` を書き換えることができる方法があれば `copy` **メソッド** でも再代入による冗長性を排除できるということになります。

実は、 Swift には `self` を書き換えるための構文がすでに存在しています。それが `mutating func` です。残念ながら、 `mutating func` は値型にしか使えませんが、 `class` でなく `struct` であれば、イミュータブルであっても自身を書き換える `copy` メソッドを作ることができます。

```swift
struct Character {
    let name: String // 名前
    let hp: Int      // HP
    let mp: Int      // MP
    let attack: Int  // 攻撃力
    let defense: Int // 防御力

    init(name: String, hp: Int, mp: Int, attack: Int, defense: Int) {
        self.name = name
        self.hp = hp
        self.mp = mp
        self.attack = attack
        self.defense = defense
    }
}

extension Character {
    mutating func copy(hp: Int? = nil, mp: Int? = nil) {
        self = Character(
            name: self.name,
            hp: hp ?? self.hp,
            mp: mp ?? self.mp,
            attack: self.attack,
            defense: self.defense
        )
    }
}

...

hero.copy(hp: hero.hp - damage)
```

この内容だと `copy` よりも `update` のような名前の方が適切ですが、重要なのは `mutating func` によって `self` 自身を書き換えていることです。

`mutating` は値型のプロパティを変更するメソッドを作るために必要なキーワードと理解されていることが多いように思います。しかし、それは `mutating func` が値型にしか使えないからそう思えるだけで、本来はレシーバーが格納されている変数（や左辺値）のメモリ領域を変更できるかどうかという意味です。参照型ではインスタンスが変数に格納されているか定数に格納されているかとは独立に、プロパティが `var` で宣言されているか `let` で宣言されているかによって変更可能かが決まります。もし参照型で `mutating func` を作ることができれば、それはメソッドの中で `self` に再代入できるということを意味するはずです。そして、それができるなら `mutating` な `copy` メソッドを実装することで、イミュータブルクラスのインスタンスを変数への再代入なしに更新することが可能になります。

現実的には、 Swift ではイミュータブルクラスより値型を優先して利用するため、参照型のための `mutating func` がほしくなるケースは稀です。きちんと理解していないと混乱を招くので、クラスで `mutating func` を作れないのは妥当かもしれません。しかし、論理的には区別できるものであり、個人的にはクラスに `mutating func` があってもキレイで良いのではないかと思います。

さて、クラスのための `mutating func` という架空の構文について長々と説明をしてきたのには理由があります。重要なのは、 **`mutating func` は `self` を `inout` で渡すことと同じ** であるということです。この考え方は後で必要になるので覚えておいて下さい。
