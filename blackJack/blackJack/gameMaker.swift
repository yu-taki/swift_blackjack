//
//  gameMaker.swift
//  blackJack
//
//  Created by H6245 on 2021/10/01.
//

import Foundation

// 組込エラー型が見つからなかったので適当に作る
enum MyError : Error {
    case UnIimplementation
    case InvalidData
}

class player{
    private let action:playerAction
    init(action:playerAction){
        self.action = action
    }
}

class game {
    private let dealer:player// ディーラー
    private let player:[player] // 将来を見据えて配列
    private let cards:cardPile //　トランプ
    private let ruleSet:rules
    init(numberOfPlayers:Int = 1 ,numberOfDeck:Int = 2, ruleSet:rules = baseRules()){
        self.ruleSet = ruleSet
        self.dealer = blackJack.player(action: blackJack.parentAction(rules: ruleSet))
        self.cards = blackJack.cardPile(numberOfDeck: numberOfDeck)
        self.player = (1...numberOfPlayers)
            .map {_ in blackJack.player(action: blackJack.childAction(rules: ruleSet))}
    }
    func startGame() {
        // トランプ山の確認
        // カード配る
        // 親のburstチェック
        // 親が閾値以上の値かチェック
        // 角子の操作
        // 勝負
        // 再戦するか？
    }
}


// スート未実装
class cards {
    private let cardDictionary = ["A":[1,11],"2":[2],"3":[3],"4":[4],"5":[5],
                                  "6":[6],"7":[7],"8":[8],"9":[9],"10":[10],
                                  "J":[10],"Q":[10],"K":[10]]
    private let displayChar:String // A,2~10,J,Q,K 型絞れるか？
    private let valueOfCard:[Int] // エースは1 or 11

    private func initValue(displayChar:String) -> [Int]{
        // switch caseで値を返す
        return []
    }
    init(displayChar:String) throws {
        // できれば新しい変数(tmpValues)を使いたくない
        guard let tmpValues = cardDictionary[displayChar] else {
            throw MyError.InvalidData
    }
        self.displayChar = displayChar
        self.valueOfCard = tmpValues
    }
    func getValues() -> [Int]{
        return self.valueOfCard
    }
    func getDisplayChar() -> String{
        return self.displayChar
    }
}

class cardPile {
    private var remainCard:[cards]
    private var usedCards:[cards] // 使い終わったカードの情報はいらない気もする
    init (numberOfDeck:Int) {
        remainCard = []
        usedCards = []
    }
    public func getNumberOfRemain() -> Int{
        return remainCard.count
    }
    public func drawCards(NumberOfDraw:Int = 1) -> [cards]{
        if (NumberOfDraw <= remainCard.count){
            let dealCards = (1...NumberOfDraw).compactMap({ret in remainCard.popLast()})
            usedCards = usedCards + dealCards;
            return dealCards;
        }else{
            // 参照渡しになっていないか要確認
            let dealCards = remainCard + (1...(NumberOfDraw - remainCard.count))
                .compactMap({ret in usedCards.popLast()})
            remainCard = usedCards
            usedCards = dealCards
            return dealCards
        }
    }
}

protocol rules {
    func isWin(targetHands:[cards],dealerHands:[cards]) -> Bool
    func isBurst(hands:[cards]) -> Bool
    func countHands(hands:[cards]) -> Int?
    func isNecessaryCardsShuffle(pile:cardPile) -> Bool
}

class baseRules:rules {
    private let NumberOfBlackJack = 21
    private let NumbersOfLeastCard = 12 // ゲーム開始に最低限必要な枚数
    
    private func sum(array:[Int]) -> Int{
        return array.reduce(0,{result, element in result + element})
    }
    
    // countHandsの結果をどこかに保持した方がいい気もする
    func isBurst(hands: [cards]) -> Bool {
        return countHands(hands: hands) == nil
    }
    
    func countHands(hands: [cards]) -> Int? {
        return hands.map({ item in item.getValues() })
            .reduce(into: [], {result ,item in result.append(sum(array: item))})
            .filter({item in item <= NumberOfBlackJack})
            .max()
    }
    func isWin(targetHands: [cards], dealerHands: [cards]) -> Bool {
        if (isBurst(hands: dealerHands)){return true}
        if (isBurst(hands: targetHands)){return false}
        let resultOfDealer = countHands(hands: dealerHands)
        let resultOfTarget = countHands(hands: targetHands)
        return resultOfTarget ?? 0 > resultOfDealer ?? 0 // nilとなるのはBustしているか、手札がない時
    }
    
    func isNecessaryCardsShuffle(pile: cardPile) -> Bool {
        return pile.getNumberOfRemain() <= NumbersOfLeastCard
    }
}


protocol playerAction {
    var hands:[cards] {get set} // この記法だと private set できない？
    var numberOfWin:Int {get set}
    var rules:rules { get };

    mutating func receiveCard(receive:[cards]) -> Void
    mutating func clearHand() -> Void
    func printHands() -> Void
    func printNumberOfWin() -> Void
}

extension playerAction {
    mutating func receiveCard(receive:[cards]) -> Void {
        self.hands = self.hands + receive
    }
    mutating func clearHand() -> Void {self.hands.removeAll()}
    func printNumberOfWin() -> Void{
        print("Win:" + String(self.numberOfWin))
    }
}

// 胴元の取れる行動
struct parentAction:playerAction {
    var rules: rules
    var hands: [cards] = []
    var numberOfWin: Int = 0
    let numberOfMinimunDealer = 17
   
    init(rules:rules){
        self.rules = rules
    }
    func printHands() {
        // 親は最初のカードを見せない
        print("hand:X," + self.hands.dropFirst()
                                 .compactMap({item in item.getDisplayChar()})
                                 .joined(separator: ","))
    }
    // func dealCards(pileCard:[cards],players:[player]) -> [cards]
    func canStopHit(hands:[cards]) -> Bool {
        !self.rules.isBurst(hands: self.hands)
        && self.rules.countHands(hands: self.hands) != nil
        // 直前で判定しているためnilを排除
        && self.rules.countHands(hands: self.hands)! < numberOfMinimunDealer
    }
}

// 打ち手の取れる行動
struct childAction:playerAction {
    var rules: rules
    var hands: [cards] = []
    var numberOfWin: Int = 0

    init(rules:rules){
        self.rules = rules
    }
    func printHands() {
        print("hand:" + self.hands.compactMap({item in item.getDisplayChar()})
                                 .joined(separator: ","))
    }
    // func stand() -> Void // 不要では？
    // func foldGame() -> Void //　不要では？
}
