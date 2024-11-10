//
//  NewsView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import SwiftUI

struct NewsView: View {
    @ObservedObject var news: NewsViewModel
    @ObservedObject var dsa: DSA

    var body: some View {
        ScrollView {
            ForEach(news.events, id: \.id) { event in
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                    switch event {
                    case let dsaEvent as DSAEvent:
                        DSAActivityView(
                            dsaEvent, dsa.getForName(dsaEvent.association))
                    case let ugentNewsEvent as UGentNewsEvent:
                        UgentNewsView(ugentNewsEvent)
                    case let specialEvent as SpecialEvent:
                        SpecialEventView(specialEvent)
                    default:
                        Text("Unknown event type")
                    }
                }
            }
            // This spacer is so we don't have entry stuck at behind the navbar
            Spacer(minLength: 30)
        }
        .padding([.horizontal], 10)
        .refreshable {
            news.loadEvents()
        }
        .task {
            news.loadEvents()
        }
    }
}

#Preview {
    NewsView(news: NewsViewModel(), dsa: DSA())
}
