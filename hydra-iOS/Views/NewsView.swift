//
//  NewsView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import SwiftUI

struct NewsView: View {
    @ObservedObject var news: NewsViewModel;
    
    var body: some View {
        ScrollView {
            ForEach(news.events) { event in
                NewsEntryView(event)
            }
            // This spacer is so we don't have entry stuck
            Spacer(minLength: 30)
        }
        .padding([.horizontal], 10)
        .onAppear {
            news.loadEvents()
        }
    }
}

#Preview {
    NewsView(news: NewsViewModel())
}
