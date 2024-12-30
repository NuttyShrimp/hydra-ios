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
        NavigationStack {
            DataLoaderView(
                dsa.associations, fetcher: dsa.loadAssocations,
                label: {
                    Label("Loading DSA Associations", image: "")
                }
            ) { _ in
                DataLoaderView(
                    news.events, fetcher: news.loadEvents, label: { Label("Loading Events", image: "") }
                ) {
                    events in
                    ScrollView {
                        LazyVStack {
                            ForEach(events, id: \.id) { event in
                                NewsEventView(dsa: dsa, event: event)
                            }
                        }
                        // This spacer is so we don't have entry stuck at behind the navbar
                        Spacer(minLength: 30)
                    }
                    .padding([.horizontal], 10)
                    .refreshable {
                        Task {
                            await news.loadEvents()
                        }
                    }
                }
            }
        }
        // We add a placeholder title so it thinks we have a title & thus can swipe between our tabs
        .navigationTitle("Nieuws")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("HydraLogo")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 10)
            }
        }
    }
}

struct NewsEventView: View {
    @ObservedObject var dsa: DSA
    var event: any Eventable
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray5))
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
}

#Preview {
    NewsView(news: NewsViewModel(), dsa: DSA())
}
