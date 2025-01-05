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
    var iconSize: CGFloat = Constants.iconSize
    
    var body: some View {
        Button(action: {
            openURL(URL(string: url)!)
        }) {
            HStack {
                label
                Spacer()
                Image(systemName: "arrow.up.forward.app")
            }
            .foregroundStyle(Color(UIColor.label))
        }

    }

    var label: some View {
        ZStack {
            if let icon = icon {
                Label(title, systemImage: icon)
            } else if let image = image {
                Label(
                    title: { Text(title) },
                    icon: {
                        Image(image)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)
                            .foregroundStyle(Color(UIColor.label))
                    })
            } else {
                Text(title)
            }
        }
    }

    struct Constants {
        static let iconSize: CGFloat = 20
    }
}

#Preview {
    WebPageButton(url: "https:///zeus.gent", title: "Zeus Gent")
}
