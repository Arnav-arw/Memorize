//
//  MemoryGame.swift
//  Memorize 3.0
//
//  Created by Arnav Singhal on 13/09/21.
//  Model

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfThatOneCard: Int?
    
    private(set) var score = 0
    
    mutating func chooseCard(_ card: Card){
        if let ChosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[ChosenIndex].isMatchedUp,
           !cards[ChosenIndex].isFaceUp
        {
            if let potentialCardMatch = indexOfThatOneCard {
                if cards[ChosenIndex].content == cards[potentialCardMatch].content {
                    cards[ChosenIndex].isMatchedUp = true
                    cards[potentialCardMatch].isMatchedUp = true
                    score+=1
                } else {
                    if cards[ChosenIndex].isAlreadySeen || cards[potentialCardMatch].isAlreadySeen {
                        score-=1
                    }
                }
            indexOfThatOneCard = nil
            } else {
                for index in cards.indices{
                    if cards[index].isFaceUp {
                        cards[index].isFaceUp = false
                        cards[index].isAlreadySeen = true
                    }
                }
                indexOfThatOneCard = ChosenIndex
            }
            cards[ChosenIndex].isFaceUp.toggle()
        }
    }
     
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(noOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<noOfPairsOfCards {
            let Content = createCardContent(pairIndex)
            cards.append(Card(content: Content, id: pairIndex*2))
            cards.append(Card(content: Content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatchedUp = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent
        let id: Int
        var isAlreadySeen = false
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatchedUp && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatchedUp && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
