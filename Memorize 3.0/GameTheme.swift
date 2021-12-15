//
//  Theme.swift
//  Memorize 3.0
//
//  Created by Arnav Singhal on 17/09/21.
//

import Foundation

struct Theme {
    var name: String
    var emoji: Array<String>
    var noOfPairsOfCards: Int
    var color: String
    
    init(name: String, emoji: Array<String>, noOfPairsOfCards: Int, color: String) {
        self.name = name
        self.emoji = emoji
        self.noOfPairsOfCards = noOfPairsOfCards > emoji.count ? emoji.count: noOfPairsOfCards
        self.color = color
    }
}
