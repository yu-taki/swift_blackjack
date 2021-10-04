//
//  rules.swift
//  blackJack
//
//  Created by H6245 on 2021/10/04.
//

import Foundation

protocol rules {
    func isWin(targetHands:[cards],dealerHands:[cards]) -> Bool
    func isBust(hands:[cards]) -> Bool
    func countHands(hands:[cards]) -> Int?
    func isNecessaryCardsShuffle(pile:cardPile) -> Bool
}

struct baseRules:rules {
    private let NumberOfBlackJack = 21
    private let NumbersOfLeastCard = 12 // ゲーム開始に最低限必要な枚数
    
    private func addArray(arrayA:[Int], arrayB:[Int]) ->[Int] {
        return Array(arrayA.map({itemA in
            arrayB.map({itemB in itemB + itemA})
        }).joined()) //flatMapの代わり
    }
    // countHandsの結果をどこかに保持した方がいい気もする
    func isBust(hands: [cards]) -> Bool {
        return countHands(hands: hands) == nil
    }
    
    func countHands(hands: [cards]) -> Int? {
        return hands.map({ item in item.getValues() })
                    .reduce(into: [0], {result ,item in result = addArray(arrayA: item, arrayB: result)})
                    .filter({item in item <= NumberOfBlackJack})
                    .max()
    }
    func isWin(targetHands: [cards], dealerHands: [cards]) -> Bool {
        if (isBust(hands: dealerHands)){return true}
        if (isBust(hands: targetHands)){return false}
        let resultOfDealer = countHands(hands: dealerHands)
        let resultOfTarget = countHands(hands: targetHands)
        return resultOfTarget ?? 0 > resultOfDealer ?? 0 // nilとなるのはBustしているか、手札がない時
    }
    
    func isNecessaryCardsShuffle(pile: cardPile) -> Bool {
        return pile.getNumberOfRemain() <= NumbersOfLeastCard
    }
}

