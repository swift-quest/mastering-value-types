protocol RandomNumberGenerator {
    mutating func next() -> UInt64
}

struct LinearCongruentialGenerator : RandomNumberGenerator {
    private var seed: UInt64

    init(seed: UInt64) {
        self.seed = seed
    }

    mutating func next() -> UInt64 {
        seed = 6364136223846793005 &* seed &+ 1442695040888963407
        return seed
    }
}

private var random = LinearCongruentialGenerator(seed: 4)
func any<C: Collection>(of collection: C) -> C.Element? where C.Index == Int {
    if collection.isEmpty { return nil }
    return collection[Int(random.next() % UInt64(collection.count)) + collection.startIndex]
}

class Character {
    let name: String // 名前
    var hp: Int      // HP
    var mp: Int      // MP
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

class Party {
    let members: [Character]

    init(members: [Character]) {
        self.members = members
    }
}

func performAttack(by character: Character, to target: Character) {
    print("\(character.name)のこうげき。")

    let damage = Swift.max(0, (character.attack - target.defense) / 2)
    target.hp -= damage

    print("\(target.name)に\(damage)のダメージ！")
    print()
}

func main() {
    let friendParty = Party(members: [
        Character(name: "ゆうしゃ", hp: 153, mp: 25, attack: 162, defense: 97),
        Character(name: "せんし", hp: 198, mp: 0, attack: 178, defense: 111),
        Character(name: "そうりょ", hp: 101, mp: 35, attack: 76, defense: 55),
        Character(name: "まほうつかい", hp: 77, mp: 58, attack: 60, defense: 57),
    ])
    let enemyParty = Party(members: [
        Character(name: "まおう", hp: 999, mp: 99, attack: 185, defense: 58),
        Character(name: "あんこくきし", hp: 250, mp: 0, attack: 181, defense: 93),
        Character(name: "デモンプリースト", hp: 180, mp: 99, attack: 121, defense: 55),
    ])

    for character in friendParty.members {
        print(character.name)
        print("HP \(character.hp)")
        print("MP \(character.mp)")
        print()
    }

    for character in friendParty.members {
        performAttack(by: character, to: any(of: enemyParty.members)!)
    }

    for character in enemyParty.members {
        performAttack(by: character, to: any(of: friendParty.members)!)
    }

    for character in friendParty.members {
        print(character.name)
        print("HP \(character.hp)")
        print("MP \(character.mp)")
        print()
    }
}

main()
