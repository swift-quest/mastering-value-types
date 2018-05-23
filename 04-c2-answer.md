# 04-c2: 値型（関数による選択） 解答の解説

## `inout` の連鎖

Swift の参照（参照型のことではなく参照渡しの（ `inout` で渡された）参照）は第一級ではありません。意図的にそのように設計されています。そのため、参照を変数に格納したり `return` することはできません。 `any(of:)` で選択された要素を参照として `return` することもできません。

`inout` で渡された参照が有効なのは関数やメソッドのローカルスコープ内だけです。クロージャに包んで外に返すようなこともできません。

```swift
func foo(_ x: inout Int) -> (() -> Void) {
    return { x += 1 } // コンパイルエラー
}
```

しかし、逆に言えばその関数やメソッドのローカルスコープにおいては参照を参照として活用できるということです。 `inout` パラメータは左辺値になれるので、 `inout` パラメータを持つ別の関数に渡して、結果を連鎖的に伝搬させることもできます。

```swift
func foo(_ x: inout Int) {
    bar(&x)
}

func bar(_ x: inout Int) {
    x += 1
}

var a = 2
foo(&a)
print(a) // 3
```

## `inout` パラメータを持つクロージャ

Swift は `inout` パラメータを持つクロージャを作ることができます。もちろん、そのようなクロージャをクロージャ式で作ることも可能です。

標準ライブラリでもこれは活用されており、たとえば `reduce(into:_:)` などがあります（[リファレンス](https://developer.apple.com/documentation/swift/array/2924692-reduce)）。

```swift
func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, Element) throws -> ()) rethrows -> Result
```

これを使えば、次のようにして `numbers` の各要素を二乗した `squares` を取得できます。

```swift
let numbers = [2, 3, 5]
let squares = numbers.reduce(into: []) { $0.append($1 * $1) }
```

普通の `reduce` はクロージャで各要素に対する処理の結果を返しますが、 `reduce(into:_:)` に渡すクロージャは何も返しません。そのかわりに `inout` パラメータで受け取った `$0` に変更を加えることで各要素に対する処理を集積していくわけです。

```swift
// 普通の `reduce` で書いた場合
let numbers = [2, 3, 5]
let squares = numbers.reduce([]) { $0 + [$1 * $1] }
```

イミュータブルクラス中心の設計だと変更は新規インスタンス生成を伴うので、普通の `reduce` のようにクロージャが結果を返す形が使いやすいですが、イミュータブルクラスの代わりに値型を使う Swift では `inout` パラメータで受け取った値に変更を加えるが自然です。

他にも `reduce(into:_:)` は `Dictionary` を組み立てる場合等に便利です。

```swift
let users: [User] = ...
let idToUser: [String: User] = users.reduce(into: [:]) { $0[$1.id] = $1 }
```

`reduce(into:_:)` が標準ライブラリに追加されたのが Swift 4 だというのは驚きです。参照渡しの高階関数というのはめずらしく、値型中心の Swift とはいえまだ充実しているとは言えません。たとえば、次のような `update` メソッドがあれば便利だと思いますが、 Swift 4.1 時点では標準ライブラリには存在しません。

```swift
extension Array {
    mutable func update(_ operation: (inout Element) -> Void) { ... }
}

var values: [Int] = [2, 3, 5]
values.update { $0 *= $0 }
print(values) // [4, 9, 25]
```

## `inout` を連鎖させてクロージャに渡す

- `inout` の連鎖
- `inout` パラメータを持つクロージャ

を組み合わせたのが [04-c2-answer.swift](04-c2-answer.swift) です。

```swift
func any<C: MutableCollection>(
    of collection: inout C,
    operation: (inout C.Element) throws -> ()
) rethrows where C.Index == Int {
    guard !collection.isEmpty else { return }
    let i = Int(random.next() % UInt64(collection.count)) + collection.startIndex
    try operation(&collection[i])
}
```

`inout` で受け取った `collection` に対して `&collection[i]` で `inout` の状態を維持したまま `operation` に渡し、クロージャの中での要素への変更を元の `collection` にまで連鎖的に波及させているわけです。

こうすれば、 `Collection` から要素を選択して処理を加えるという一連の過程を `inout` のまま行うことができます。ライフサイクルの厳しい `inout` だけど、 `operation` がクロージャとして外出しされているのがおもしろいところです。

```swift
for character in friendParty.members {
    any(of: &enemyParty.members) { performAttack(by: character, to: &$0) }
}
```

この方法も万能とは言えず、たとえば同じような処理を連続して行うとクロージャ式がネストして可読性が良くないという問題があります。そういう場合は処理を適切に関数に切り出すことで可読性を保つことができるでしょう。今のコードも、もし `performAttack` が関数に切り出されておらずにクロージャ式の中に展開されていると可読性は良くないと思います。しかし、 `inout` で受け取った値を `inout` パラメータを持つクロージャに渡して変更を連鎖させるというテクニックは、値型とうまく付き合うための一つの解になると思います。

---

- [次の課題](05-a.md)
