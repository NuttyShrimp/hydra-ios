//
//  DSAActivity.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 29/10/2024.
//

import SwiftUI

struct DSAActivityView: View {
    private let transaction: Transaction = .init(animation: .linear)

    let event: DSAEvent
    let association: Association

    init(_ event: DSAEvent, _ organiser: Association) {
        self.event = event
        self.association = organiser
    }

    var body: some View {
        Button(action: {
            debugPrint("abc")
        }) {
            HStack(alignment: .top) {
                Text(event.title)
                    .align(.left)
                Spacer()
                if association.logo != nil {
                    AsyncImage(url: association.logo, transaction: transaction)
                    { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 75, maxHeight: 75)
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .imageScale(.large)
                                .foregroundColor(.gray)
                                .frame(width: 75, height: 75)
                        } else {
                            ProgressView()
                                .frame(width: 75, height: 75)
                        }
                    }
                }
            }
            .modifier(
                Eventify(
                    event: event, startDate: event.startTime,
                    endDate: event.endTime)
            )
            .padding()
        }
        .foregroundStyle(Color(UIColor.label))
    }
}

//#Preview {
//    DSAActivityView()
//}
