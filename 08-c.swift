struct Character {
    let name: String // 名前
    let maxHP: Int   // 最大HP
    var hp: Int      // HP
    let maxMP: Int   // 最大MP
    var mp: Int      // MP
    let attack: Int  // 攻撃力
    let defense: Int // 防御力

    init(name: String, maxHP: Int, maxMP: Int, attack: Int, defense: Int) {
        self.name = name
        self.maxHP = maxHP
        self.maxMP = maxMP
        self.attack = attack
        self.defense = defense

        self.hp = maxHP
        self.mp = maxMP
    }
}

struct Party {
    var members: [Character]

    init(members: [Character]) {
        self.members = members
    }
}

extension Party {
    var leader: Character {
        get { return members[0] }
        set { members[0] = newValue }
    }
}

enum Spell {
    case attack(name: String, mp: Int, damage: Int)
    case restoration(name: String, mp: Int, quantity: Int)

    var name: String {
        switch self {
        case .attack(let name, _, _): return name
        case .restoration(let name, _, _): return name
        }
    }

    var mp: Int {
        switch self {
        case .attack(_, let mp, _): return mp
        case .restoration(_, let mp, _): return mp
        }
    }
}

extension Spell {
    static let fireball: Spell = .attack(name: "ファイアボール", mp: 5, damage: 70)
    static let healing: Spell = .restoration(name: "ヒーリング", mp: 5, quantity: 80)
}

extension MutableCollection {
    mutating func update(_ operation: (inout Element) -> Void) {
        for index in indices {
            operation(&self[index])
        }
    }
}

func performAttack(by character: inout Character, to target: inout Character) {
    print("\(character.name)のこうげき。")

    let damage = Swift.max(0, (character.attack - target.defense) / 2)
    target.hp -= damage
    character.hp += damage

    print("\(target.name)に\(damage)のダメージ！")
    print("\(character.name)のHPがかいふくした。")
    print()
}

func performSpell(_ spell: Spell, by character: inout Character, to target: inout Character) {
    defer { print() }

    print("\(character.name)は\(spell.name)のまほうをつかった。")

    guard character.mp >= spell.mp else {
        print("しかしMPがたりない。")
        return
    }

    character.mp -= spell.mp

    switch spell {
    case .attack(_, _, let damage):
        target.hp -= damage
        print("\(target.name)に\(damage)のダメージ！")
    case .restoration(_, _, let quantity):
        target.hp = Swift.min(target.maxHP, target.hp + quantity)
        print("\(target.name)のHPがかいふくした。")
    }
}

func main() {
    var friendParty = Party(members: [
        Character(name: "ゆうしゃ", maxHP: 153, maxMP: 25, attack: 162, defense: 97),
        Character(name: "せんし", maxHP: 198, maxMP: 0, attack: 178, defense: 111),
        Character(name: "そうりょ", maxHP: 101, maxMP: 35, attack: 76, defense: 55),
        Character(name: "まほうつかい", maxHP: 77, maxMP: 58, attack: 60, defense: 57),
    ])
    var enemyParty = Party(members: [
        Character(name: "まおう", maxHP: 999, maxMP: 99, attack: 185, defense: 58),
        Character(name: "あんこくきし", maxHP: 250, maxMP: 0, attack: 181, defense: 93),
        Character(name: "デモンプリースト", maxHP: 180, maxMP: 99, attack: 121, defense: 55),
    ])

    friendParty.leader.hp = 1

    for character in friendParty.members {
        print(character.name)
        print("HP \(character.hp)")
        print("MP \(character.mp)")
        print()
    }

    friendParty.members.update { character in
        performSpell(.healing, by: &character, to: &friendParty.leader)
    }

    enemyParty.members.update { character in
        performSpell(.healing, by: &character, to: &enemyParty.leader)
    }

    for character in friendParty.members {
        print(character.name)
        print("HP \(character.hp)")
        print("MP \(character.mp)")
        print()
    }
}

main()
