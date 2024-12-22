//
//  OnboardingView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 21/12/2024.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @ObservedObject var analytics: AnalyticsDocument

    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingWelcome(currentPage: $currentPage)
                .tag(0)
            OnboardingAnalytics(analytics: analytics, currentPage: $currentPage)
                .tag(1)
            OnboardingNewsFeed().tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color(.secondarySystemBackground))
        // To add a sliding animation when we change the currentpage binding (https://stackoverflow.com/questions/61827496/swiftui-how-to-animate-a-tabview-selection)
        .animation(.easeInOut(duration: 1.0), value: currentPage)
        .transition(.slide)
    }
}

#Preview {
    OnboardingView(analytics: AnalyticsDocument())
}
