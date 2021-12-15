//
//  EmojiMemoryGame.swift
//  Memorize 3.0
//
//  Created by Arnav Singhal on 13/09/21.
//  ViewModel

import Foundation
import SwiftUI

class emojiMemoryGame: ObservableObject {
    
    typealias Card = MemoryGame<String>.Card
    
    static let themes: Array<Theme> = [
        Theme(
            name: "Faces",
            emoji: ["😥","😭","😱","😖","😣","😞","😓","😩","😫","😤","😡","😠","😈","👿"],
            noOfPairsOfCards: 10,
            color: "orange"
            ),
        Theme(
            name: "Cats",
            emoji: ["😺","🐱","😹","😻","😼","😽","🙀","😿","😾"],
            noOfPairsOfCards: 6,
            color: "yellow"
            ),
        Theme(
            name: "Hearts",
            emoji: ["💘","💝","💖","💗","💓","💞","💕","💟","💔","💛","💚","💙","💜"],
            noOfPairsOfCards: 8,
            color: "pink"
            ),
        Theme(
            name: "Vehicles",
            emoji: ["🚀","🚁","🚂","🚃","🚄","🚅","🚆","🚈","🚋","🚌","🚍","🚎","🚐","🚑","🚒"],
            noOfPairsOfCards: 10,
            color: "red"
            ),
        Theme(
            name: "Flags",
            emoji: ["🇮🇹","🇯🇪","🇯🇲","🇯🇴","🇯🇵","🇰🇪","🇰🇬","🇰🇭","🇰🇮","🇰🇷","🇰🇼","🇰🇾","🇰🇿","🇱🇦","🇱🇧"],
            noOfPairsOfCards: 10,
            color: "grey"
            ),
        Theme(
            name: "Fruits",
            emoji: ["🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🍒","🍑","🍍","🥥"],
            noOfPairsOfCards: 10,
            color: "blue"
            )
    ]
    
    static func createMemorygame (_ theme: Theme) -> MemoryGame<String> {
        MemoryGame<String>( noOfPairsOfCards: theme.noOfPairsOfCards) { pairIndex in
        theme.emoji[pairIndex]
        }
    }
    
    @Published private var model = createMemorygame(themes.randomElement()!)
    
    private var theme: Theme = themes.randomElement()!
    
    var themeName: String {
        theme.name
    }
    
    var themeColor: Color {
        switch theme.color {
        case "grey":
            return .gray
        case "red":
            return .red
        case "yellow":
            return .yellow
        case "pink":
            return .pink
        case "orange":
            return .orange
        case "blue":
            return .blue
        default:
            return .black
        }
    }
    
    var scorecard: Int {
        return model.score
    }
    
    var cards: Array<Card> {
        model.cards
    }
    
    func choose(card: Card) {
        model.chooseCard(card)
    }
    
    func newGame() {
        theme = emojiMemoryGame.themes.randomElement()!
        theme.emoji.shuffle()
        model = emojiMemoryGame.createMemorygame(theme)
    }
    
    func shuffle() {
        model.shuffle()
    }
}

