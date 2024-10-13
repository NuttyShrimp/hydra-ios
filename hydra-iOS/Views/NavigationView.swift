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
            VStack {
                TabView(selection: $navigationModel.currentTab) {
                    NewsView().tag(0)
                    RestoView().tag(1)
                    SettingsView().tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack {
                    Button(action: {
                        navigationModel.selectTab(0)
                    }) {
                        VStack {
                            Image(systemName: "newspaper.fill")
                            if navigationModel.currentTab == 0 {
                                Text("News")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(navigationModel.currentTab == 0 ? Color.accentColor : .gray)

                    Button(action: {
                        navigationModel.selectTab(1)
                    }) {
                        VStack {
                            Image(systemName: "fork.knife")
                            if navigationModel.currentTab == 1 {
                                Text("Resto")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(navigationModel.currentTab == 1 ? Color.accentColor : .gray)

                    Button(action: {
                        navigationModel.selectTab(2)
                    }) {
                        VStack {
                            Image(systemName: "gear")
                            if navigationModel.currentTab == 2 {
                                Text("Settings")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(navigationModel.currentTab == 2 ? Color.accentColor : .gray)
                }
                .padding()
                .frame(width: 300.0, height: 60.0, alignment: .center)
                .background(Color(.systemGray6))
                .mask(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

#Preview {
    NavigationView(navigationModel: Navigation())
}
