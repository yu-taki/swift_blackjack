//
//  rules.swift
//  blackJack
//
//  Created by H6245 on 2021/10/04.
//

import Foundation

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

