//
//  NewsView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 18/10/2024.
//

import SwiftUI

struct UgentNewsView: View {
    let event: UgentNewsEntry
    @Environment(\.openURL) var openURL

    init(_ card: UgentNewsEntry) {
        self.event = card
    }

    var body: some View {
        Button(action: {
            openURL(event.link)
        }) {
            HStack {
                Text(event.title)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .modifier(
                Eventify(eventType: .UGent, startDate: event.published)
            )
            .padding()
        }
        .foregroundStyle(Color(UIColor.label))
    }
}

#Preview {
    let entry = UgentNewsEntry(
        id: "1", title: "FLASH: De spaghetti is op in de Brug",
        summary:
            "Vanaf vandaag is er GEEN spaghetti meer te koop in studenten restaurant de Brug",
        content: "", link: URL(string: "https://zeus.gent")!,
        published: Date.now, updated: Date.now)
    UgentNewsView(entry)
}
