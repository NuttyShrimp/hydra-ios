//
//  TextAlignment.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import SwiftUI

enum Alignment {
    case left
    case right
}

struct TextAlignment: ViewModifier {
    let alignment: Alignment
    
    init(alignment: Alignment) {
        self.alignment = alignment
    }
    
    func body(content: Content) -> some View {
        HStack {
            if alignment == .right {
                Spacer()
            }
            content
                .multilineTextAlignment(.leading)
            if alignment == .left {
                Spacer()
            }
        }
    }
}

extension View {
    func align(_ alignment: Alignment) -> some View {
        self.modifier(TextAlignment(alignment: alignment))
    }
}
