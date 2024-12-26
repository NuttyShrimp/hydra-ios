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
            NavbarButton(tab: .events, navigationModel: navigationModel)
            NavbarButton(tab: .resto, navigationModel: navigationModel)
            NavbarButton(tab: .info, navigationModel: navigationModel)
            NavbarButton(tab: .settings, navigationModel: navigationModel)
        }
        .frame(width: 300.0, height: 60.0, alignment: .center)
        .background(Color(.systemBackground))
        .mask(RoundedRectangle(cornerRadius: 15))
    }
}

struct NavbarButton: View {
    let tab: MainTabs
    let navigationModel: Navigation
    
    var body: some View {
        Button(action: {
            navigationModel.selectTab(tab)
        }) {
            VStack {
                Image(systemName: tab.icon)
                if navigationModel.currentTab == tab {
                    Text(tab.title)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(navigationModel.currentTab == tab ? Color.accentColor : .gray)
    }
}
