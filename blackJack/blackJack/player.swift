//
//  player.swift
//  blackJack
//
//  Created by H6245 on 2021/10/04.
//

import Foundation

// TODO Actionへの型制約 playerActionを実装している型を許容したい
struct player<Action>{
    var action:Action
    init(action:Action){
        self.action = action
    }
}

protocol playerAction {
    var hands:[cards] {get set}
    var numberOfWin:Int {get set}
    var rules:rules {get};

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
protocol dealerAction:playerAction {
    func canStopHit() -> Bool
}
// 胴元の取れる行動
struct parentAction:dealerAction{
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
    func canStopHit() -> Bool {
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
}
