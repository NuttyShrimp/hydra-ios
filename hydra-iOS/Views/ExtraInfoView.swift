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
            DataLoaderView(info.info, fetcher: info.loadInfo) { entries in
                List(entries) { entry in
                    ExtraInfoEntryView(entry: entry)
                }
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
            if let image = entry.image {
                if let mappedIcon = ExtraInfoEntryView.Constants.iconMapping[image] {
                    WebPageButton(url: url, title: entry.title, icon: mappedIcon)
                } else {
                    WebPageButton(url: url, title: entry.title, image: entry.image)
                }
            } else {
                WebPageButton(url: url, title: entry.title)
            }
        } else if entry.html != nil {
            NavigationLink(
                destination: {
                    ExtraInfoWebView(entry: entry)
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

    struct Constants {
        static let iconMapping: [String: String] = [
            "info_heart": "heart.fill",
            "info_academiccalendar": "calendar",
        ]
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
            if let mappedIcon = ExtraInfoEntryView.Constants.iconMapping[icon] {
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
    }
}

struct ExtraInfoWebView: View {
    var entry: InfoEntry
    @State var isLoading: Bool = true
    @State var html: String = ""

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            } else {
                WebView(text: html)
            }
        }
        .task {
            do {
                isLoading = true
                html = try await entry.loadWebPage()
                isLoading = false
            } catch {
                debugPrint("Error loading web page: \(error)")
            }
        }
    }
}

#Preview {
    ExtraInfoView(info: ExtraInfoDocument())
}
