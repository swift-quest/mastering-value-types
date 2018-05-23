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

func performAttack(by character: Character, to target: Character) {
    print("\(character.name)のこうげき。")

    let damage = Swift.max(0, (character.attack - target.defense) / 2)
    target.hp -= damage

    print("\(target.name)に\(damage)のダメージ！")
    print()
}

func main() {
    let hero = Character(name: "ゆうしゃ", hp: 153, mp: 25, attack: 162, defense: 97)
    let archfiend = Character(name: "まおう", hp: 999, mp: 99, attack: 185, defense: 58)

    print(hero.name)
    print("HP \(hero.hp)")
    print("MP \(hero.mp)")
    print()

    performAttack(by: hero, to: archfiend)
    performAttack(by: archfiend, to: hero)

    print(hero.name)
    print("HP \(hero.hp)")
    print("MP \(hero.mp)")
    print()
}

main()
