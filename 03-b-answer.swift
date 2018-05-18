class Character {
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

class Party {
    let members: [Character]

    init(members: [Character]) {
        self.members = members
    }
}

extension Party {
    var leader: Character {
        return members[0]
    }

    func copy(leader: Character? = nil) -> Party {
        guard let leader = leader else { return self }
        var members = self.members
        members[0] = leader
        return Party(members: members)
    }
}

func performAttack(by character: Character, to target: inout Character) {
    print("\(character.name)のこうげき。")

    let damage = Swift.max(0, (character.attack - target.defense) / 2)
    target = target.copy(hp: target.hp - damage)

    print("\(target.name)に\(damage)のダメージ！")
    print()
}

func main() {
    var friendParty = Party(members: [
        Character(name: "ゆうしゃ", hp: 153, mp: 25, attack: 162, defense: 97),
        Character(name: "せんし", hp: 198, mp: 0, attack: 178, defense: 111),
        Character(name: "そうりょ", hp: 101, mp: 35, attack: 76, defense: 55),
        Character(name: "まほうつかい", hp: 77, mp: 58, attack: 60, defense: 57),
    ])
    var enemyParty = Party(members: [
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
        var target = enemyParty.leader
        performAttack(by: character, to: &target)
        enemyParty = enemyParty.copy(leader: target)
    }

    for character in enemyParty.members {
        var target = friendParty.leader
        performAttack(by: character, to: &target)
        friendParty = friendParty.copy(leader: target)
    }

    for character in friendParty.members {
        print(character.name)
        print("HP \(character.hp)")
        print("MP \(character.mp)")
        print()
    }
}

main()
