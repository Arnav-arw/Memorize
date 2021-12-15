//
//  ContentView.swift
//  Memorize 3.0
//
//  Created by Arnav Singhal on 13/09/21.
//
//  View
 
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: emojiMemoryGame
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack (alignment: .bottom) {
            VStack {
                topInfo
                gameBody
                bottomButtons
            }
            deckBody
        }
    }
    
    var bottomButtons: some View {
        HStack {
            Button(action: {
                withAnimation {
                    dealt = []
                    viewModel.newGame()
                }}
                   , label: { Text("New Game") })
            Spacer()
            Button(action: { withAnimation { viewModel.shuffle() }}, label: { Text("Shuffle")} )
        }
        .padding(.horizontal)
    }
    
    var topInfo: some View {
        HStack{
            Text("Theme: \(viewModel.themeName)")
            Spacer()
            Text("Score: \(viewModel.scorecard)")
        }
        .padding(.horizontal)
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal (_ card: emojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt (_ card: emojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation (for card: emojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = viewModel.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (Double(2)/Double(viewModel.cards.count))
        }
        return Animation.easeInOut(duration: Double(0.5)).delay(delay)
    }
    
    
    var gameBody: some View {
        VStack{
            AspectVGrid(items: viewModel.cards, aspectRatio: 2/3) { card in
                if card.isMatchedUp && !card.isFaceUp {
                    Color.clear
                } else {
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .padding(4)
                        .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                        .onTapGesture { withAnimation { viewModel.choose(card: card) }}
                }
            }
            .padding(.horizontal)
            .foregroundColor(viewModel.themeColor)
        }
    }
    
    var deckBody: some View {
        ZStack{
            ForEach(viewModel.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: 60, height: 90)
        .foregroundColor(viewModel.themeColor)
        .onTapGesture {
                //deal cards
                for card in viewModel.cards {
                    withAnimation(dealAnimation(for: card)) {
                        deal(card)
                }
            }
        }
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                    .padding(5)
                    .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatchedUp ? 360 : 0))
                    .padding(5)
                    .font(Font.system(size: DrawingConstants.fontSize))
                    // view modifications like this .scaleEffect are not affected by the call to .animation ABOVE it
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .modifier(Cardify(isFaceUp: card.isFaceUp))
            }
        }
    
    private func scale(thatFits size: CGSize) -> CGFloat{
        min(size.width, size.height) / (32/0.6)
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height)*0.6)
    }
    
    private struct DrawingConstants {
            static let fontScale: CGFloat = 0.7
            static let fontSize: CGFloat = 32
        }
    
}

 

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = emojiMemoryGame()
        Group {
            ContentView(viewModel: game)
                .preferredColorScheme(.light)
        }
    }
}
