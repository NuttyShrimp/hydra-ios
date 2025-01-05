//
//  WebPageButton.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 25/12/2024.
//

import SwiftUI

struct WebPageButton: View {
    @Environment(\.openURL) var openURL
    var url: String
    var title: String
    var icon: String?
    var image: String?
    var iconSize: CGFloat?

    var body: some View {
        if let iconSize = iconSize {
            IconButton(title: title, icon: icon, image: image, iconSize: iconSize, external: true, action: {
                openURL(URL(string: url)!)
            })
        } else {
            IconButton(title: title, icon: icon, image: image, external: true, action: {
                openURL(URL(string: url)!)
            })
        }
    }
}

#Preview {
    WebPageButton(url: "https:///zeus.gent", title: "Zeus Gent")
}
