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
        // カード配る(胴元へ)
        // カード配る(各打ち手へ)
        // 親のburstチェック
        // 親が閾値以上の値かチェック
            // 必要ならdrawを繰り返す
        // 各打ち手の操作
        // 勝負
        // 再戦するか？
    }
}
