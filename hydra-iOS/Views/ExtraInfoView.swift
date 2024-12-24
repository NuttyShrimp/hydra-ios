//
//  InfoTabView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 24/12/2024.
//

import SwiftUI

struct ExtraInfoView: View {
    @ObservedObject var info: ExtraInfoDocument

    var body: some View {
        NavigationStack {
            List(info.entries) { entry in
                ExtraInfoEntryView(entry: entry)
            }
        }
        .navigationTitle("Info")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await info.loadInfo()
        }
    }
}

struct ExtraInfoEntryView: View {
    var entry: InfoEntry
    var body: some View {
        if let url = entry.url {
            WebPageButton(url: url, title: entry.title, icon: entry.image)
        } else if let html = entry.html {
            NavigationLink(
                destination: {
                    WebView(text: html)
                },
                label: {
                    ExtraInfoLabel(entry.title, entry.image)
                }
            )
        } else if let subs = entry.subcontent {
            NavigationLink(
                destination: {
                    List(subs) { sub in
                        ExtraInfoEntryView(entry: sub)
                    }
                    .navigationTitle(entry.title)
                },
                label: {
                    ExtraInfoLabel(entry.title, entry.image)
                }
            )
        } else {
            Text(entry.title)
        }
    }

}

struct WebPageButton: View {
    @Environment(\.openURL) var openURL
    var url: String
    var title: String
    var icon: String?

    var body: some View {
        Button(action: {
            openURL(URL(string: url)!)
        }) {
            HStack {
                ExtraInfoLabel(title, icon)
                Spacer()
                Image(systemName: "arrow.up.forward.app")
            }
            .foregroundStyle(Color(UIColor.label))
        }

    }
}

struct ExtraInfoLabel: View {
    var title: String
    var icon: String?

    init(_ title: String, _ icon: String? = nil) {
        self.title = title
        self.icon = icon
    }

    var body: some View {
        if let icon = icon {
            if let mappedIcon = Constants.iconMapping[icon] {
                Label(title, systemImage: mappedIcon)
            } else {
                Label(
                    title: { Text(title) },
                    icon: {
                        Image(icon)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: Constants.iconSize, maxHeight: Constants.iconSize)
                    })
            }
        } else {
            Text(title)
        }
    }

    struct Constants {
        static let iconSize: CGFloat = 24
        static let iconMapping: [String: String] = [
            "info_heart": "heart.fill",
            "info_academiccalendar": "calendar",
        ]
    }
}

#Preview {
    ExtraInfoView(info: ExtraInfoDocument())
}
