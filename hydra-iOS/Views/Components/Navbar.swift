//
//  Navbar.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 18/10/2024.
//

import SwiftUI

struct Navbar: View {
    @ObservedObject var navigationModel: Navigation;

    var body: some View {
        HStack {
            Button(action: {
                navigationModel.selectTab(.events)
            }) {
                VStack {
                    Image(systemName: "newspaper.fill")
                    if navigationModel.currentTab == .events {
                        Text("Nieuws")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(navigationModel.currentTab == .events ? Color.accentColor : .gray)
            
            Button(action: {
                navigationModel.selectTab(.resto)
            }) {
                VStack {
                    Image(systemName: "fork.knife")
                    if navigationModel.currentTab == .resto {
                        Text("Resto")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(navigationModel.currentTab == .resto ? Color.accentColor : .gray)

            Button(action: {
                navigationModel.selectTab(.info)
            }) {
                VStack {
                    Image(systemName: "info")
                    if navigationModel.currentTab == .info {
                        Text("Info")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(navigationModel.currentTab == .info ? Color.accentColor : .gray)
            
            Button(action: {
                navigationModel.selectTab(.settings)
            }) {
                VStack {
                    Image(systemName: "gear")
                    if navigationModel.currentTab == .settings {
                        Text("Instellingen")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(navigationModel.currentTab == .settings ? Color.accentColor : .gray)
        }
        .frame(width: 300.0, height: 60.0, alignment: .center)
        .background(Color(.systemBackground))
        .mask(RoundedRectangle(cornerRadius: 15))
    }
}
