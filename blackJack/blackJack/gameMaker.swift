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

struct gameMaker {
    private var dealer:player<dealerAction>
    private var player:player<playerAction>
    private var cards:cardPile //　トランプ
    private let ruleSet:rules
    init(numberOfDeck:Int = 2, ruleSet:rules = baseRules()){
        self.ruleSet = ruleSet
        self.dealer = blackJack.player(action: blackJack.parentAction(rules: ruleSet))
        self.cards = blackJack.cardPile(numberOfDeck: numberOfDeck)
        self.player = blackJack.player(action: blackJack.childAction(rules: ruleSet))
    }
    mutating func startGame() {
        // トランプ山の確認
        if(ruleSet.isNecessaryCardsShuffle(pile: self.cards)) { cards.shuffleCards() }
        // カード配る(胴元へ)
        self.dealer.action.receiveCard(receive: cards.drawCards(NumberOfDraw:2))
        // カード配る(打ち手へ)
        self.player.action.receiveCard(receive:cards.drawCards(NumberOfDraw:2))
        // 親が閾値以上の値かチェック
        while(!self.dealer.action.canStopHit()){
            self.dealer.action.receiveCard(receive: cards.drawCards())
        }
        // 各打ち手の操作(stand,hit,fold)
        // 勝負(メソッドにするべき)
        if(self.ruleSet.isBurst(hands: self.player.action.hands)){
            self.player.action.numberOfWin = self.player.action.numberOfWin + 1
        }else if (self.ruleSet.isBurst(hands: self.dealer.action.hands)){
            self.dealer.action.numberOfWin = self.dealer.action.numberOfWin + 1
        }else {
            if(self.ruleSet.isWin(targetHands: self.player.action.hands,
                                  dealerHands: self.dealer.action.hands)){
                self.player.action.numberOfWin = self.player.action.numberOfWin + 1
            }else{
                self.dealer.action.numberOfWin = self.dealer.action.numberOfWin + 1
            }
        }
        // 再戦するか？
    }
}
