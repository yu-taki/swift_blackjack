//
//  player.swift
//  blackJack
//
//  Created by H6245 on 2021/10/04.
//

import Foundation

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
