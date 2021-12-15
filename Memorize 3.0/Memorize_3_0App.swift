//
//  Memorize_3_0App.swift
//  Memorize 3.0
//
//  Created by Arnav Singhal on 13/09/21.
//

import SwiftUI

@main
struct Memorize_2_0App: App {
    let game = emojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
