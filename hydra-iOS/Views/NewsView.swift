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
            if news.isLoading {
                ProgressView()
                    .task {
                        await dsa.loadAssocations()
                        await news.loadEvents()
                    }
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(news.events, id: \.id) { event in
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
                    // This spacer is so we don't have entry stuck at behind the navbar
                    Spacer(minLength: 30)
                }
                .padding([.horizontal], 10)
                .refreshable {
                    await news.loadEvents()
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

#Preview {
    NewsView(news: NewsViewModel(), dsa: DSA())
}
