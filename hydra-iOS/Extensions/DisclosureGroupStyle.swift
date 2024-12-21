//
//  DisclosureGroupStyle.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 21/12/2024.
//

import SwiftUI

struct PlainDisclosureGroupStyle: DisclosureGroupStyle {
    func makeBody(configuration: DisclosureGroupStyle.Configuration) -> some View {
        VStack {
            HStack {
                configuration.label
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    configuration.isExpanded.toggle()
                }
            }
        }
        if configuration.isExpanded {
            configuration.content
                .listRowSeparator(.hidden, edges: .top)
        }

    }
}

extension DisclosureGroupStyle where Self == PlainDisclosureGroupStyle {
    internal static var plain: PlainDisclosureGroupStyle { PlainDisclosureGroupStyle() }
}
