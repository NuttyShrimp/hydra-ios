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
                    if event is DSAEvent {
                        let dsaEvent = (event as? DSAEvent)!
                        DSAActivityView(
                            dsaEvent, dsa.getForName(dsaEvent.association))
                    }
                    if event is UgentNewsEntry {
                        UgentNewsView((event as? UgentNewsEntry)!)
                    }
                }
            }
            // This spacer is so we don't have entry stuck at behind the navbar
            Spacer(minLength: 30)
        }
        .padding([.horizontal], 10)
        .onAppear {
            news.loadEvents()
        }
    }
}

#Preview {
    NewsView(news: NewsViewModel(), dsa: DSA())
}
