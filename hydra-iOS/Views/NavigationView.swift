//
//  ContentView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 07/10/2024.
//
import SwiftUI

struct NavigationView: View {
    @MainActor @ObservedObject var navigationModel: Navigation
    @StateObject var newsViewModel = NewsViewModel()
    @StateObject var dsa = DSA()
    @StateObject var restos = RestoDocument()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack {
                    TabView(selection: $navigationModel.currentTab) {
                        // TODO: dsa should be stored somewhere because this data is has a lesser change at getting stale between tab changes then the news entries
                        NewsView(news: newsViewModel, dsa: dsa)
                            .padding([.bottom], 10)
                            .tag(MainTabs.events)
                        RestoView(restos: restos)
                            .tag(MainTabs.resto)
                        SettingsView(restos: restos).tag(MainTabs.settings)
                            .toolbar(.hidden, for: .tabBar)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .background(Color(.systemGray6))
                }
                .safeAreaInset(edge: .bottom) {
                    Navbar(navigationModel: navigationModel)
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity)
                        .padding(-20)
                        .background {
                            Color(.systemGray6)
                                .background(.ultraThinMaterial)
                                .mask(alignment: .top) {
                                    VStack(spacing: 0) {
                                        LinearGradient(
                                            stops: [
                                                Gradient.Stop(
                                                    color: .clear,
                                                    location: .zero),
                                                Gradient.Stop(
                                                    color: .black, location: 1.0
                                                ),
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                        .frame(height: 20)
                                        Color(.systemGray6)
                                    }
                                }
                                .padding(.top, -45)
                                .ignoresSafeArea()
                        }
                }
            }
        }
    }
}

#Preview {
    NavigationView(navigationModel: Navigation())
        .environmentObject(AnalyticsDocument())
}

#Preview("Resto focused") {
    let navModel = Navigation()
    navModel.currentTab = .resto
    return NavigationView(navigationModel: navModel)
        .environmentObject(AnalyticsDocument())
}
