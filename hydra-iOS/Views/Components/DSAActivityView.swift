//
//  DSAActivity.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 29/10/2024.
//

import SwiftUI

struct DSAActivityView: View {
    let event: DSAEvent
    let association: Association

    init(_ event: DSAEvent, _ organiser: Association) {
        self.event = event
        self.association = organiser
    }

    var body: some View {
        NavigationLink(destination: {
            DSAEventDetailView(event: event, association: association)
        }) {
            HStack(alignment: .top) {
                VStack {
                    Text(event.title)
                        .align(.left)
                    Text(association.name)
                        .font(Constants.FontStyle.assocationName)
                        .align(.left)
                }
                Spacer()
                if let logo = association.logo {
                    HAsyncImage(url: logo, size: Constants.Image.size)
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
    
    struct Constants {
        struct FontStyle {
            static let assocationName: Font = Font.system(size: 18, weight: .medium)
        }
        struct Image {
            static let size: CGFloat = 75
        }
    }
}

//#Preview {
//    DSAActivityView()
//}
