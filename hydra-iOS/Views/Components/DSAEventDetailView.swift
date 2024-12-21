//
//  DSAEventDetailView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 20/12/2024.
//

import LucideIcons
import SwiftUI

struct DSAEventDetailView: View {
    let event: DSAEvent
    let association: Association
    @Environment(\.openURL) var openURL

    // TODO: Move to grey cards instead of this list
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(event.title)
                .font(.title2)
                .fontWeight(.bold)
                .align(.left)
            Grid(alignment: .top, horizontalSpacing: Constants.gridSpacing, verticalSpacing: Constants.gridSpacing) {
                if let location = event.location {
                    // TODO: Open location in maps (MKLocalSearch)
                    GridRow(alignment: .center) {
                        Image(uiImage: Lucide.mapPin)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Constants.iconSize, height: Constants.iconSize)
                        Text(location)
                            .align(.left)
                    }
                }
                GridRow {
                    Image(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Constants.iconSize, height: Constants.iconSize)
                    VStack {
                        Text("Start: \(event.startTime.formatted())")
                            .align(.left)
                        if let endDate = event.endTime {
                            Text("Einde: \(endDate.formatted())")
                                .align(.left)
                        }
                    }
                }
                GridRow {
                    if let logo = association.logo {
                        HAsyncImage(url: logo, size: Constants.iconSize * 1.5)
                    }
                    Button(action: {
                        if let url = association.website {
                            openURL(url)
                        }
                    }) {
                        VStack {
                            Text(association.name)
                                .align(.left)
                            if let description = association.description {
                                Text(description)
                                    .font(.footnote)
                                    .align(.left)
                                    .frame(maxHeight: 200)
                            }
                        }
                    }.buttonStyle(.plain)
                }
            }
            if let description = event.description {
                Text("Beschrijving")
                    .fontWeight(.semibold)
                Text(description)
            }
            Spacer()
        }
        .padding()
    }

    struct Constants {
        static let iconSize: CGFloat = 35
        static let gridSpacing: CGFloat = 20
    }
}
