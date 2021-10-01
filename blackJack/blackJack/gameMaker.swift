//
//  gameMaker.swift
//  blackJack
//
//  Created by H6245 on 2021/10/01.
//

import Foundation

class game {
    private let dealer:player// ディーラー
    private let player:[player] // 将来を見据えて配列
    private let cards:cardPile //　トランプ
    private let ruleSet:rules
    init(){
        
    }
    func startGame() {
        // トランプ山の確認
        // カード配る
        // 親のカードチェック
        // 子の操作
        // 勝負
        // 再戦するか？
    }
}

class player{
    private let hands:[cards]
    private let numberOfWin:Int = 0
    init(){
        
    }
}

class cards {
    private let displayChar:String
    private let valueOfCard:[Int]
    init(){
    }
}

class cardPile {
    private let remainCard:[cards]
    private let usedCards:[cards] // 使い終わったカードの情報はいらない気もする
    init () {
    }
}

protocol rules {
    func isWin(targetHands:[cards],dealerHands:[cards]) -> Bool
    func isBurst(hands:[cards]) -> Bool
    func isNecessaryCardsShuffle(pile:cardPile) -> Bool
}

protocol dealerAction {
    func dealCards(pileCard:[cards]) -> [cards]
    func canStopHit(hands:[cards]) -> Bool
}

protocol playerAction {
    func hit(remainCard:[cards]) -> cards
    func stand()
    func foldGame()
}

protocol systemAction {
    func printCards(_:[cards]) -> Void
    func printNumberOfWin(_:[player]) -> Void
}
