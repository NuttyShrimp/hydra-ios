//
//  SettingsAboutView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 25/12/2024.
//

import AlertToast
import SwiftUI

struct SettingsAboutView: View {
    @Environment(\.openURL) var openURL
    @AppStorage("zeusModeEnabled") var zeusMode = false
    @State private var zeusClickCount = 0
    @State private var showZeusToast = false

    var body: some View {
        List {
            Section {
                Text(
                    "Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")"
                )
                WebPageButton(
                    url: "https://github.com/NuttyShrimp/hydra-ios/releases", title: "Changelog")
                WebPageButton(
                    url: "https://github.com/NuttyShrimp/hydra-ios/issues/new", title: "Feedback")
            }
            Section {
                IconButton(
                    title: "Made by Zeus WPI", image: "ZeusLogo", iconSize: Constants.logoSize,
                    external: true,
                    action: {
                        if zeusMode {
                            openURL(URL(string: "https://zeus.ugent.be")!)
                            return
                        }
                        zeusClickCount += 1
                        showZeusToast = true
                        if zeusClickCount == 3 {
                            zeusMode = true
                            return
                        }
                    })
                WebPageButton(
                    url: "https://dsa.ugent.be",
                    title: "In samenwerking met Dienst Studentenactiviteiten", image: "UgentLogo",
                    iconSize: Constants.logoSize)
                WebPageButton(
                    url: "https://gentsestudentenraad.be",
                    title: "Met de steun van de Gentse Studentenraad", image: "GsrLogo",
                    iconSize: Constants.logoSize)
            }
        }
        .toast(isPresenting: $showZeusToast) {
            if zeusClickCount == 3 {
                AlertToast(
                    displayMode: .hud, type: .complete(.green), title: "Zeus mode ingeschakeld")
            } else {
                AlertToast(
                    displayMode: .hud, type: .regular,
                    title: "Nog \(3 - zeusClickCount) keer klikken voor Zeus mode in te schakelen")
            }
        }
    }

    struct Constants {
        static let logoSize: CGFloat = 50
    }
}

#Preview {
    SettingsAboutView()
}
