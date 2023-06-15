//
//  Cardify.swift
//  Memorize 3.0
//
//  Created by Arnav Singhal on 03/10/21.
//

import Foundation
import SwiftUI

struct Cardify: AnimatableModifier {
    
    init (isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double
    
    func body (content: Content) -> some View {
        ZStack {
            let Shape = RoundedRectangle(cornerRadius: DrawingConstant.cornerRadius)
            if rotation < 90 {
                Shape.fill().foregroundColor(.white)
                Shape.strokeBorder(lineWidth: DrawingConstant.lineWidth)
            } else {
                Shape.fill()
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
    
    private struct DrawingConstant {
        static let lineWidth: CGFloat = 3
        static let cornerRadius: CGFloat = 12
    }
}
