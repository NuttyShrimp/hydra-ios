//
//  ContentView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 07/10/2024.
//
import SwiftUI

struct NavigationView: View {
    @MainActor @ObservedObject var navigationModel: Navigation
    @ObservedObject var newsViewModel = NewsViewModel()
    @ObservedObject var dsa = DSA()
    @ObservedObject var restos = Restos()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack {
                    TabView(selection: $navigationModel.currentTab) {
                        // TODO: dsa should be stored somewhere because this data is has a lesser change at getting stale between tab changes then the news entries
                        NewsView(news: newsViewModel, dsa: dsa)
                            .tag(0)
                            .padding([.bottom], 10)
                        RestoView(restos: restos)
                            .tag(1)
                        SettingsView().tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
}

#Preview("Resto focused") {
    let navModel = Navigation()
    navModel.currentTab = 1
    return NavigationView(navigationModel: navModel)
}
