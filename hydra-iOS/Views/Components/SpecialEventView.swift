//
//  SpecialEventView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import SwiftUI

struct SpecialEventView: View {
    private let transaction: Transaction = .init(animation: .easeInOut)
    
    let event: SpecialEvent
    
    @Environment(\.openURL) var openURL

    init(_ event: SpecialEvent) {
        self.event = event
    }

    var body: some View {
        Button(action: {
            openURL(event.link)
        }) {
            HStack {
                Text(event.name)
                    .align(.left)
                Spacer()
                if event.image != nil {
                    AsyncImage(url: event.image, transaction: transaction) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 75, maxHeight: 75)
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .imageScale(.large)
                                .foregroundColor(.gray)
                                .frame(width: 75, height: 75)
                        } else {
                            ProgressView()
                                .frame(width: 75, height: 75)
                        }
                    }
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
