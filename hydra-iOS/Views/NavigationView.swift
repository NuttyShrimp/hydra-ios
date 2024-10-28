//
//  ContentView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 07/10/2024.
//
import SwiftUI

struct NavigationView: View {
    @ObservedObject var navigationModel: Navigation;

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack {
                    TabView(selection: $navigationModel.currentTab) {
                        NewsView(news: NewsViewModel())
                            .tag(0)
                            .padding([.bottom], 10)
                        RestoView().tag(1)
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
                                                Gradient.Stop(color: .clear, location: .zero),
                                                Gradient.Stop(color: .black, location: 1.0)
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
