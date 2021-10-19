//
//  gameMaker.swift
//  blackJack
//
//  Created by H6245 on 2021/10/01.
//

import Foundation

// 組込エラー型が見つからなかったので適当に作る
enum MyError: Error {
    case UnIimplementation
    case InvalidData
}

struct gameMaker {
    private var dealer: player<dealerAction>
    private var player: player<playerAction>
    private var cards: cardPile //　トランプ
    private let ruleSet: rules
    init(numberOfDeck: Int = 2, ruleSet: rules = baseRules()) {
        self.ruleSet = ruleSet
        self.dealer = black.player(action: black.parentAction(rules: ruleSet))
        self.cards = black.cardPile(numberOfDeck: numberOfDeck)
        self.player = black.player(action: black.childAction(rules: ruleSet))
    }
    private mutating func gameProcess() -> Void {
        // 手札の破棄
        dealer.action.hands.removeAll()
        player.action.hands.removeAll()
        // トランプ山の確認
        if(ruleSet.isNecessaryCardsShuffle(pile: self.cards)) { cards.shuffleCards() }
        // カード配る(胴元へ)
        self.dealer.action.receiveCard(receive: cards.drawCards(NumberOfDraw: 2))
        // カード配る(打ち手へ)
        self.player.action.receiveCard(receive: cards.drawCards(NumberOfDraw: 2))
        // 親が閾値以上の値かチェック
        while(!self.dealer.action.canStopHit()) {
            self.dealer.action.receiveCard(receive: cards.drawCards())
        }

        dealer.action.printOtherCard()

        // playerActionでメソッド化をしたい
        // 戻り値の想定は enumで{勝負へ行く,負ける}の二択で良さそう
        // 各打ち手の操作(stand,hit,fold)
        repeat {
            player.action.printHands()
            if(player.action.rules.isBust(hands: player.action.hands)) {
                print("bustしました")
                dealer.action.numberOfWin += 1
                return
            }
            print("あなたの現在の値" + String(ruleSet.countHands(hands: player.action.hands) ?? 0))
            print("1:hit(カードを引く)")
            print("2:stand(勝負へ進む)")
            print("3:fold(ゲームから降りる)")

            let input = readLine() ?? ""
            print("\n")
            if(input == "1") {
                player.action.receiveCard(receive: cards.drawCards())
            } else if(input == "2") { break; }
            else if(input == "3") {
                print("ゲームから降りました")
                dealer.action.numberOfWin += 1
                return
            }
        } while(true)

        // 勝負(メソッドにするべき)
        dealer.action.printHands()
        print("ディーラーの現在の値" + String(ruleSet.countHands(hands: dealer.action.hands) ?? 0))
        player.action.printHands()
        print("あなたの現在の値" + String(ruleSet.countHands(hands: player.action.hands) ?? 0))

        if(self.ruleSet.isBust(hands: self.player.action.hands)) {
            print("bustしています")
            self.dealer.action.numberOfWin += 1
        } else if (self.ruleSet.isBust(hands: self.dealer.action.hands)) {
            print("ディーラーがbustしています")
            self.player.action.numberOfWin += 1
        } else {
            if(self.ruleSet.isWin(targetHands: self.player.action.hands,
                dealerHands: self.dealer.action.hands)) {
                print("あなたの勝ち\n")
                self.player.action.numberOfWin += 1
            } else {
                print("あなたの負け\n")
                self.dealer.action.numberOfWin += 1
            }
        }
    }

    public mutating func startGame() {
        var keyInput: String = ""
        repeat {
            print("ゲームを始めますか？")
            print("1:始める,0:終わる")
            keyInput = readLine() ?? ""
            print("\n")
            if(keyInput == "1") {
                gameProcess()
            } else if (keyInput == "0") {
                break
            }
            print("あなたの勝利数")
            player.action.printNumberOfWin()
            print("ディーラーの勝利数")
            dealer.action.printNumberOfWin()
        } while(true)
    }
}
