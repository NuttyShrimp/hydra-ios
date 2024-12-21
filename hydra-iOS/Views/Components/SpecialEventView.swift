//
//  SpecialEventView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import SwiftUI

struct SpecialEventView: View {
    let event: SpecialEvent
    
    @Environment(\.openURL) var openURL

    init(_ event: SpecialEvent) {
        self.event = event
    }

    var body: some View {
        Button(action: {
            openURL(event.link)
        }) {
            HStack(alignment: .top) {
                Text(event.name)
                    .align(.left)
                Spacer()
                if let image = event.image {
                    HAsyncImage(url: image, size: 75)
                }
            }
            .modifier(
                Eventify(
                    event: event, startDate: event.start,
                    endDate: event.end)
            )
            .padding()
        }
        .foregroundStyle(Color(UIColor.label))
    }
}
