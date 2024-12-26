//
//  Navbar.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 18/10/2024.
//

import SwiftUI

struct Navbar: View {
    @ObservedObject var navigationModel: Navigation;
    @AppStorage("zeusModeEnabled") var zeusMode = false

    var body: some View {
        HStack {
            NavbarButton(tab: .events, navigationModel: navigationModel)
            NavbarButton(tab: .resto, navigationModel: navigationModel)
            NavbarButton(tab: .info, navigationModel: navigationModel)
            if zeusMode {
                NavbarButton(tab: .zeus, navigationModel: navigationModel)
            }
            NavbarButton(tab: .settings, navigationModel: navigationModel)
        }
        .frame(width: 300.0, height: 60.0, alignment: .center)
        .background(Color(.systemBackground))
        .mask(RoundedRectangle(cornerRadius: 15))
    }
}

// TODO: Image in buttons hover higher than icons
struct NavbarButton: View {
    let tab: MainTabs
    @ObservedObject var navigationModel: Navigation
    
    var body: some View {
        Button(action: {
            navigationModel.selectTab(tab)
        }) {
            VStack {
                if let icon = tab.icon {
                    Image(systemName: icon)
                } else if let image = tab.image {
                    Image(image)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 30)
                }
                if navigationModel.currentTab == tab {
                    Text(tab.title)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(navigationModel.currentTab == tab ? Color.accentColor : .gray)
    }
}
