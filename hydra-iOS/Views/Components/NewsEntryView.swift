//
//  NewsView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 18/10/2024.
//

import SwiftUI

struct NewsEntryView: View {
    let event: NewsEvent
    
    init(_ card: NewsEvent) {
        self.event = card
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .frame(maxHeight: 100)
            VStack {
                if event.image != nil {
                    AsyncImage(url: event.image) { image in
                        image.resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxHeight: 300)
                    } placeholder: {
                        ProgressView()
                        .frame(width: 50, height: 50)
                    }
                }
                Text(event.title)
                    .multilineTextAlignment(.center)
                if event.creationDate < Date.now && event.finishDate != nil {
                    Text(event.finishDate!.ISO8601Format())
                } else {
                    Text(event.creationDate.ISO8601Format())
                }
            }
        }
    }
}

#Preview {
    let entry = NewsEvent(id: "1", title: "FLASH: De spaghetti is op in de Brug", description: "Vanaf vandaag is er GEEN spaghetti meer te koop in studenten restaurant de Brug", image: nil, creationDate: Date.now, finishDate: nil, url: nil)
    NewsEntryView(entry)
}
#Preview("With Image") {
    let entry = NewsEvent(id: "1", title: "FLASH: De spaghetti is op in de Brug", description: "Vanaf vandaag is er GEEN spaghetti meer te koop in studenten restaurant de Brug", image: URL(string: "https://pics.zeus.gent/O5F4Q3Vt.png"), creationDate: Date.now, finishDate: nil, url: nil)
    NewsEntryView(entry)
}
