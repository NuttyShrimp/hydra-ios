//
//  IconButton.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 05/01/2025.
//

import SwiftUI

struct IconButton: View {
    var title: String
    var icon: String?
    var image: String?
    var iconSize: CGFloat = Constants.iconSize
    var external: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                label
                Spacer()
                if external {
                    Image(systemName: "arrow.up.forward.app")
                }
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
                            .foregroundStyle(Color(UIColor.label))
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)
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
