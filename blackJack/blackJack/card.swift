//
//  card.swift
//  blackJack
//
//  Created by H6245 on 2021/10/04.
//

import Foundation

// スート未実装
struct cards {
    private static let cardDictionary = ["A":[1,11],"2":[2],"3":[3],"4":[4],"5":[5],
                                  "6":[6],"7":[7],"8":[8],"9":[9],"10":[10],
                                  "J":[10],"Q":[10],"K":[10]]
    private let displayChar:String // A,2~10,J,Q,K 型絞れるか？
    private let valueOfCard:[Int] // エースは1 or 11

    init(displayChar:String) throws {
        // できれば新しい変数(tmpValues)を使いたくない
        guard let tmpValues = cards.cardDictionary[displayChar] else {
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
    static func getCardDictionary() -> Dictionary<String,[Int]>{
        return cards.cardDictionary
    }
}

struct cardPile {
    private var remainCard:[cards]
    private var usedCards:[cards]
    init (numberOfDeck:Int) {
        self.usedCards = []
        do {
            // *4は、ダイヤ・ハート・クラブ・スペード分
            self.remainCard = try (1...numberOfDeck * 4)
                .reduce(into: [], {result,
                    // 静的関数を使うなジェネリックにした方がいい気がする
                    _ in result = result + cards.getCardDictionary().keys
                })
                .compactMap({item in try cards(displayChar: item)})
        }catch {
            print("UnExcepted Error")
            // こういうエラーをどうすればいいか？
            self.remainCard = []
        }
    }

    public func getNumberOfRemain() -> Int{
        return remainCard.count
    }
    
    public mutating func drawCards(NumberOfDraw:Int = 1) -> [cards]{
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
    public mutating func shuffleCards(){
        remainCard = (remainCard + usedCards).shuffled()
        usedCards = []
    }
}
