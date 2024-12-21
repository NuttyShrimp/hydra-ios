//
//  HAsyncImage.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 20/12/2024.
//

import SwiftUI

struct HAsyncImage: View {
    let url: URL
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: url, transaction: .init(animation: .linear))
        { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: size, maxHeight: size)
            } else if phase.error != nil {
                Image(systemName: "photo")
                    .imageScale(.large)
                    .foregroundColor(.gray)
                    .frame(width: size, height: size)
            } else {
                ProgressView()
                    .frame(width: size, height: size)
            }
        }
    }
}
